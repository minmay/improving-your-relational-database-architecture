CREATE SEQUENCE xxxs_seq;

CREATE TABLE xxxs (
	id INTEGER PRIMARY KEY DEFAULT nextval ('xxxs_seq'),
	uidlog INTEGER CONSTRAINT xxxs_uidlog_nn NOT NULL DEFAULT 1,
	version INTEGER CONSTRAINT xxxs_version_nn NOT NULL DEFAULT 1,
	create_time TIMESTAMP CONSTRAINT xxxs_create_time_nn NOT NULL DEFAULT CURRENT_TIMESTAMP,
	modify_time TIMESTAMP CONSTRAINT xxxs_modify_time_nn NOT NULL DEFAULT CURRENT_TIMESTAMP
);

ALTER SEQUENCE xxxs_seq OWNED BY xxxs.id;

CREATE SEQUENCE xxxs_h_seq;

CREATE TABLE xxxs_h (
	id INTEGER PRIMARY KEY DEFAULT nextval('xxxs_h_seq'),
	log_op VARCHAR(50) CONSTRAINT xxxs_h_log_op_nn NOT NULL,
	log_time TIMESTAMP CONSTRAINT xxxs_h_log_time_nn NOT NULL DEFAULT CURRENT_TIMESTAMP,
	xxx_id INTEGER CONSTRAINT xxxs_h_xxx_id_nn NOT NULL,
	uidlog INTEGER CONSTRAINT xxxs_h_xxx_uidlog_nn NOT NULL,
	version INTEGER CONSTRAINT xxxs_h_version_nn NOT NULL,
	create_time TIMESTAMP CONSTRAINT xxxs_h_create_time_nn NOT NULL,
	modify_time TIMESTAMP CONSTRAINT xxxs_h_modify_time_nn NOT NULL
);

ALTER SEQUENCE xxxs_h_seq OWNED BY xxxs_h.id;

CREATE TRIGGER xxxs_update_trigger
BEFORE UPDATE OR DELETE ON xxxs
    FOR EACH ROW EXECUTE PROCEDURE audit_update_trigger();

COMMENT ON SEQUENCE xxxs_seq IS 'The sequence for the table xxxs.';

COMMENT ON TABLE xxxs IS 'xxxs';
COMMENT ON COLUMN xxxs.id IS 'The primary key for this row.';
COMMENT ON COLUMN xxxs.yyy IS 'Lorem ipsum dolor sit.';
COMMENT ON COLUMN xxxs.uidlog IS 'The id of the user or application that last changed this row.';
COMMENT ON COLUMN xxxs.version IS 'The version number for this row.';
COMMENT ON COLUMN xxxs.create_time IS 'The timestamp for when this row was created.';
COMMENT ON COLUMN xxxs.modify_time IS 'The timestamp for when this row was modified.';

COMMENT ON TABLE xxxs_h IS 'The xxxs audit table.';
COMMENT ON COLUMN xxxs_h.id IS 'The primary key for this audit table.';
COMMENT ON COLUMN xxxs_h.log_op IS 'The operation on the modified row.';
COMMENT ON COLUMN xxxs_h.log_time IS 'The timestamp for when this operation took place.';
COMMENT ON COLUMN xxxs_h.xxx_id IS 'The primary key for the xxxs row that was updated.';
COMMENT ON COLUMN xxxs_h.yyy IS 'Lorem ipsum dolor sit.';
COMMENT ON COLUMN xxxs_h.uidlog IS 'The id of the user or application that last changed this row.';
COMMENT ON COLUMN xxxs_h.version IS 'The version number for this row.';
COMMENT ON COLUMN xxxs_h.create_time IS 'The timestamp for when the xxxs row was created.';
COMMENT ON COLUMN xxxs_h.modify_time IS 'The timestamp for when the xxxs row was modified.';

COMMENT ON SEQUENCE xxxs_h_seq IS 'The sequence for the table xxxs_h.';

COMMENT ON TRIGGER xxxs_update_trigger ON xxxs IS 'The audit trail update trigger for table xxxs.';