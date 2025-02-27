using DataFrames, DataFramesMeta, Chain, StatFiles, Statistics, Parameters, LinearAlgebra, CSV

@with_kw mutable struct ProjectPaths
    Data::String = "data/"
    GpssData::String = "GPSS-Replication-ICPSR/data/"
end