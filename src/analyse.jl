using Dates;
using DataFrames;
using JSON;
using JSONTables;
using Plots;
using TextAnalysis;
using Languages;

# Travailler sur le fichier puis le fermer automatiquement

open("src/data/archipel.json") do file
    # Transformer en DataFrame
    json = JSON.parse(file)
    global df = DataFrame(json)
end

df