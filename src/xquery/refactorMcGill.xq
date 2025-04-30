declare namespace arthist = "arthist" ;
(:~
 : This script refactor umontreal data
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
declare namespace etdms = "http://www.ndltd.org/standards/metadata/etdms/1-0/";
declare namespace update = "http://basex.org/modules/update" ;

let $records := for $file in file:list('/Users/emmanuelchateau/ouvroir/arthist/src/data/harvest/umontreal/', false(), '*.xml') return fn:doc("/Users/emmanuelchateau/ouvroir/arthist/src/data/harvest/umontreal/" || $file)
let $harRecords := $records//oai:record[oai:metadata/*:thesis/*:degree[*:name="Doctor of Philosophy"][*:discipline="Department of Art History and Communication Studies"]]
let $content := <oai:OAI-PMH>{
  $records[1]/oai:OAI-PMH/oai:responseDate,
  <ListRecords>{$harRecords}</ListRecords>
}</oai:OAI-PMH>

(: return file:write("/Users/emmanuelchateau/ouvroir/arthist/src/data/" || "etdms-mcgill.xml", $content) :)
return $harRecords