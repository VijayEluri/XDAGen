<#assign field_prefix = table_alias + "." />
select -- rows of ${relid}
<#if include_table_field_columns>  ${table_alias}.*,${"\n"}</#if>  -- row_xml
  <#if convert_to_clob>xmlserialize(content </#if>xmlelement("${row_element_name}"<#if xmlns??>, xmlattributes('${xmlns}' as "xmlns")</#if>
   ,xmlforest(
     <#list all_fields as f>
     ${field_prefix}${f.name} "${f.name?lower_case}"${f_has_next?string(',','')}  <#-- ,xmlelement("${f.name?lower_case}", ${field_prefix}${f.name}) -->
     </#list>
    )
   -- <#if (child_subqueries![])?size == 0>No</#if> child tables for ${relid}
   <#list child_subqueries![] as child_subquery>
   ,(${child_subquery}
    ) -- child subquery
   </#list>
   -- <#if (parent_subqueries![])?size == 0>No</#if> parent tables for ${relid}
   <#list parent_subqueries![] as parent_subquery>
   ,(${parent_subquery}
    ) -- parent subquery
   </#list>
  )<#if convert_to_clob> as clob)</#if> row_xml
from ${relid.idString} ${table_alias}<#if ((filter_condition!"")?length > 0)>
where
  ${filter_condition}</#if>