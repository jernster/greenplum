-- Function: public.deploy_permissions(text, text, text, text)

-- DROP FUNCTION public.deploy_permissions(text, text, text, text);

CREATE OR REPLACE FUNCTION public.deploy_permissions(text, text, text, text)
  RETURNS SETOF text AS
$BODY$
DECLARE
    grant_or_revoke ALIAS for $1;
    perms ALIAS for $2;
    usr_group ALIAS for $3;
    schemanm ALIAS for $4;
    tablenames text :='';
    viewnames text :='';
    seqnames text :='';
BEGIN

FOR tablenames IN SELECT (grant_or_revoke || ' ' || perms || ' on ' || lower(schemanm) ||'.'|| tablename || ' to ' || lower(usr_group) || ';')
  from pg_catalog.pg_tables where schemaname = lower(schemanm)
loop
return next tablenames;
end loop;

FOR viewnames IN SELECT (grant_or_revoke || ' ' || perms || ' on ' || lower(schemanm) ||'.'|| viewname || ' to ' || lower(usr_group) || ';')
  from pg_catalog.pg_views where schemaname = lower(schemanm)
loop
return next viewnames;
end loop;

FOR seqnames IN SELECT (grant_or_revoke || ' ' || perms || ' on ' || lower(schemanm) ||'.'|| sequence_name || ' to ' || lower(usr_group) || ';')
  from information_schema.sequences where sequence_schema = lower(schemanm)
loop
return next seqnames;
end loop;
return;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION public.deploy_permissions(text, text, text, text)
  OWNER TO gpadmin;
