using Dates;
using DataFrames;
using JSON;
using HTTP;


const repository = "https://spectrum.library.concordia.ca"
const oaipmh = "https://spectrum.library.concordia.ca/cgi/oai2"
const set = "74797065733D746865736973"
const metadataPrefix = "oai_etdms"
const exemple = "https://spectrum.library.concordia.ca/cgi/oai2?verb=ListRecords&metadataPrefix=oai_etdms&set=74797065733D746865736973"
const lastHarvested = now()

function request(oaipmh, set, prefix, lastHarvested)
    resp = HTTP.get(oaipmh; query=[
        ("verb", "ListRecords"),
        ("metadataPrefix", prefix),
        ("set", set)]
      )
    open("test-oai.xml", "a") do io
        write(io, resp)
    end
end

req = request(oaipmh, set, metadataPrefix, lastHarvested)