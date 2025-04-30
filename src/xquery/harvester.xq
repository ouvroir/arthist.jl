declare namespace arthist = "arthist" ;
(:~
 : This script harverst oai-pmh repositories
 :
 : @author emchateau (Ouvroir d’histoire de l’art et de muséologie numériques)
 : @licence GNU-GPL >3
 : @since 2025-04
 : @version 0.1
 :)
declare namespace csv = "http://basex.org/modules/csv" ;
declare namespace file = "http://expath.org/ns/file" ;
declare namespace http = "http://expath.org/ns/http-client" ;
declare namespace json = "http://basex.org/modules/json" ;
declare namespace map = "http://www.w3.org/2005/xpath-functions/map" ;
declare namespace oai = "http://www.openarchives.org/OAI/2.0/";
declare namespace update = "http://basex.org/modules/update" ;


declare variable $arthist:repositories-ca := json:doc("/Users/emmanuelchateau/ouvroir/arthist/src/data/repositories-ca.json");

(:~
 : this function get records
 : @param $institution institution shortname
 : @param $format metadata format (according to the oaipmh repository)
 : @param $token oai-pmh resumption token if it exists or an empty value
 : @return an http request from the oai-pmh repository
 :)
declare function arthist:getRecords($institution, $format, $token){
  let $params := arthist:getQueryParams($institution) 
  let $url := if ($token != '') 
    then $params?oaipmh || '?verb=ListRecords&amp;resumptionToken=' || $token
    else $params?oaipmh || '?verb=ListRecords&amp;metadataPrefix=' || $format || '&amp;set=' || $params?set
  return http:send-request(
    <http:request method="get"/>, 
    $url
  )
};

(:~
 : this function get query params
 : @param $institution institution shortname
 : @return a map with key values from the repositories file
 :)
declare function arthist:getQueryParams($institution){
  let $repo := $arthist:repositories-ca/json/repositories/_[shortname=$institution]
  return map {
    "shortname" : $institution,
    "name" : $repo/name,
    "repository" : $repo/repository,
    "oaipmh" : $repo/oaipmh,
    "set" : $repo/thesis-set
  }
};

(:~
 : this function creates records files
 : @param $institution shortname
 : @param $format metadata format (according to the oaipmh repository)
 : @param $token? oai-pmh resumption token if it exists
 : @return write a file for each page of oai-pmh results
 :
 : @bug the last file doesnt have an id, use $records instead ?
 :)
declare function arthist:writeRecords($institution, $format, $token){
  let $records := arthist:getRecords($institution, $format, $token)
  let $token := $records[2]/oai:OAI-PMH/oai:ListRecords/oai:resumptionToken
  return 
  if ($token!='') 
  then (
    file:write("/Users/emmanuelchateau/ouvroir/arthist/src/data/harvest/" || $institution || "/" || $format || '-' || fn:generate-id($token) || '.xml', $records[2]), 
    arthist:harvest($institution, $format, $token)
  )
  else file:write("/Users/emmanuelchateau/ouvroir/arthist/src/data/harvest/" || $institution || "/" || $format || '-' || fn:generate-id($token) || '.xml', $records[2])
};


declare function arthist:harvest($institution, $format, $token){
  arthist:writeRecords($institution, $format, $token)
};



(:~
let $doc := fn:doc("../data/archipel.xml")/thesis/doc
return csv:serialize(<csv>{arthist:getContent($doc)}</csv>)
:)
arthist:harvest("mcgill", "oai_etdms", '')