declare namespace arthist = 'arthist' ;

declare function arthist:getContent($doc){
  for $doc in $doc
  return <record>{
    $doc/department,
    $doc/institution,
    <author>{
      $doc/creators/*/name/family || ', ' || $doc/creators/*/name/given}</author>,
    $doc/title,
    $doc/date,
    $doc/keywords,
    <advisor>{
      $doc/contributors/*/name/family || ', ' || $doc/contributors/*/given }</advisor>,
      $doc/uri,
      $doc/abstract
  }</record>
};

let $doc := fn:doc("../data/archipel.xml")/thesis/doc
return csv:serialize(<csv>{arthist:getContent($doc)}</csv>)
