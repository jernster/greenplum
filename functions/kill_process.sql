CREATE OR REPLACE FUNCTION public.kill_process(pid integer)
RETURNS boolean AS $BODY$
DECLARE
    qry boolean;

BEGIN
    qry := (select pg_catalog.pg_cancel_backend(pid));
    RETURN qry;
END;

$BODY$
    LANGUAGE plpgsql
    SECURITY DEFINER
    VOLATILE
    RETURNS NULL ON NULL INPUT;

GRANT EXECUTE ON FUNCTION public.kill_process(pid integer) TO user;
