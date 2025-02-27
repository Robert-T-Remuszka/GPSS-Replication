include("main.jl")
Paths = ProjectPaths()
@unpack_ProjectPaths Paths
# %%
#====================
The Goal is to Replicate line 152 of GPSS's "make_rotemberg_summary_BAR.do" which writes

> bartik_weight, z(t*_`ind_stub'*) weightstub(t*_`growth_stub'*) x(`x') y(`y')  controls(`controls') weight_var(`weight')  absorb(czone)

where the locals are
    y = wage_ch,
    x = emp_ch,
    controls = t*_init_male t*_init_race_white t*_init_native_born t*_init_educ_hs t*_init_educ_coll t*_init_veteran t*_init_nchild year_*,
    weight = pop1980,
    growth_stub = nat1980_empl_ind_,
    ind_stub = init_sh_ind_

Their bartik_weight command is described in "bartik_weight.ado" of the author's replication package. Let's see how this works.
====================#
RotembergReady = @chain DataFrame(CSV.File(Data * "RotembergReady.csv")) begin
    @select(Not(:test)) # This is an auxilliary variable I think
    @orderby(:czone, :year)
end

# Create cz fixed effects
CZs = unique(RotembergReady[:,:czone])
varnames = [Symbol("cz" * string(cz) * "fe") for cz in CZs]
for (cz,varname) in zip(CZs,varnames)
    @transform!(RotembergReady, $(varname) = :czone .== cz)
    @transform!(RotembergReady, $(varname) = convert.(Float64, $(varname)))
end
@select!(RotembergReady, Not(:cz100fe))                           # Drop one fe

# Create time fixed effects
years = [1980, 1990, 2000]
tfevarnames = [Symbol("year_"*string(y)) for y in 1:3]
for (year, varname) in zip(years, tfevarnames)
    @transform!(RotembergReady, $(varname) = :year .== year)
    @transform!(RotembergReady, $(varname) = convert.(Float64, $(varname)))
end
@select!(RotembergReady, Not(:year_1))                            # Drop one fe

# Other rhs vars
weightname = :pop1980;
controls = filter(x -> startswith(x,"t") && x[7:10] == "init" && x[12:13] != "sh", names(RotembergReady));
growth_stub = filter(x -> startswith(x,"t") && x[7:9] == "nat", names(RotembergReady));
ind_stub = filter(x -> startswith(x,"t") && x[12:13] == "sh", names(RotembergReady));

Y = RotembergReady[:, :wage_ch];
X = RotembergReady[:, :emp_ch];
G = collect(RotembergReady[1,growth_stub]);
Z = Matrix(RotembergReady[:,ind_stub]);
N = size(X)[1]
K = size(Z)[2]
fes = Matrix(RotembergReady[:,varnames[2:end]])
tfes = Matrix(RotembergReady[:,tfevaranmes[2:end]])
D = hcat(Matrix(RotembergReady[:,controls]), fes, tfes, ones(N));          # GPSS refer to this as W in their code
weight = diagm(collect(RotembergReady[:,weightname]));
weight2 = collect(RotembergReady[:,weightname]);

MD = I - D * inv(D' * weight * D) * D' * weight;                     # Annihilator
Z̃ = MD * Z;
X̃ = MD * X;
Ỹ = MD * Y;
α = (diagm(G) * Z' * weight * X̃) / (G' * Z' * weight * X̃)
# %%
#=
For each year there are 228 industries. You can sum across industries in a year, say 1980 to get panel
C 1980 sum
=#
sum(α[1:228])

#=
More intersing are the sums across time which tell us something about the relative importance of the industry
=#
αK = vcat(I(228), I(228), I(228))' * α
maximum(αK)