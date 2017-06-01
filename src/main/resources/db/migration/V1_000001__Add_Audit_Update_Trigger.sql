CREATE OR REPLACE FUNCTION audit_update_trigger() RETURNS TRIGGER AS $audit_update_trigger$

 BEGIN

 IF (TG_OP = 'UPDATE') AND (NEW.uidlog > 0) THEN
   EXECUTE format('INSERT INTO %I_h SELECT nextval(''%I_h_seq''), %L, now(), ($1).*', TG_TABLE_NAME, TG_TABLE_NAME, TG_OP) USING OLD;
   NEW.version := OLD.version + 1;
   NEW.modify_time := CURRENT_TIMESTAMP;
   RETURN NEW;
 ELSEIF (TG_OP = 'DELETE') THEN
   EXECUTE format('INSERT INTO %I_h SELECT nextval(''%I_h_seq''), %L, now(), ($1).*', TG_TABLE_NAME, TG_TABLE_NAME, TG_OP) USING OLD;
   RETURN OLD;
 END IF;

   RETURN NEW;  -- THIS IS A CREATE, JUST RETURN IT
 END;

$audit_update_trigger$ LANGUAGE plpgsql;

COMMENT ON FUNCTION audit_update_trigger() IS 'This function is used for auditing, version, and timestamping all tables.  Apply it as an UPDATE and DELETE trigger.';