select f.status,f.tablespace_name,f.contents,f.em,f.ssm,space "sum_space(m)",
       space-nvl(free_space,0) "used_space(m)",
       round((1-nvl(free_space,0)/space)*100,2) "used_rate(%)",free_space "free_space(m)"
from
    (select file_id,file_name,tablespace_name,round(sum(bytes)/(1024*1024),2) space
     from dba_data_files
     group by tablespace_name,file_id,file_name) d,
    (select file_id,tablespace_name,round(sum(bytes)/(1024*1024),2) free_space
     from dba_free_space
     group by tablespace_name,file_id) e,
    (select status,tablespace_name,contents,extent_management em,segment_space_management ssm from dba_tablespaces) f
where d.tablespace_name = e.tablespace_name(+) and d.file_id = e.file_id(+) and d.tablespace_name = f.tablespace_name(+);