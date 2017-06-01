CREATE SEQUENCE presenters_seq;

CREATE TABLE presenters (
	id INTEGER PRIMARY KEY DEFAULT nextval ('presenters_seq'),
	name VARCHAR(255) CONSTRAINT presenters_name_nn NOT NULL DEFAULT 'TBD',
	biograhy TEXT,
	uidlog INTEGER CONSTRAINT presenters_uidlog_nn NOT NULL DEFAULT 1,
	version INTEGER CONSTRAINT presenters_version_nn NOT NULL DEFAULT 1,
	create_time TIMESTAMP CONSTRAINT presenters_create_time_nn NOT NULL DEFAULT CURRENT_TIMESTAMP,
	modify_time TIMESTAMP CONSTRAINT presenters_modify_time_nn NOT NULL DEFAULT CURRENT_TIMESTAMP
);

ALTER SEQUENCE presenters_seq OWNED BY presenters.id;

CREATE SEQUENCE presenters_h_seq;

CREATE TABLE presenters_h (
	id INTEGER PRIMARY KEY DEFAULT nextval('presenters_h_seq'),
	log_op VARCHAR(50) CONSTRAINT presenters_h_log_op_nn NOT NULL,
	log_time TIMESTAMP CONSTRAINT presenters_h_log_time_nn NOT NULL DEFAULT CURRENT_TIMESTAMP,
	presenter_id INTEGER CONSTRAINT presenters_h_presenter_id_nn NOT NULL,
	name VARCHAR(255) CONSTRAINT presenters_name_nn NOT NULL,
	biograhy TEXT,
	uidlog INTEGER CONSTRAINT presenters_h_uidlog_nn NOT NULL,
	version INTEGER CONSTRAINT presenters_h_version_nn NOT NULL,
	create_time TIMESTAMP CONSTRAINT presenters_h_create_time_nn NOT NULL,
	modify_time TIMESTAMP CONSTRAINT presenters_h_modify_time_nn NOT NULL
);

ALTER SEQUENCE presenters_h_seq OWNED BY presenters_h.id;

CREATE TRIGGER presenters_update_trigger
BEFORE UPDATE OR DELETE ON presenters
    FOR EACH ROW EXECUTE PROCEDURE audit_update_trigger();

COMMENT ON SEQUENCE presenters_seq IS 'The sequence for the table presenters.';

COMMENT ON TABLE presenters IS 'presenters';
COMMENT ON COLUMN presenters.id IS 'The primary key for this row.';
COMMENT ON COLUMN presenters.name IS 'The full name of the presenter.';
COMMENT ON COLUMN presenters.biograhy IS 'A short professional biography about the presenter. ';
COMMENT ON COLUMN presenters.uidlog IS 'The id of the user or application that last changed this row.';
COMMENT ON COLUMN presenters.version IS 'The version number for this row.';
COMMENT ON COLUMN presenters.create_time IS 'The timestamp for when this row was created.';
COMMENT ON COLUMN presenters.modify_time IS 'The timestamp for when this row was modified.';

COMMENT ON TABLE presenters_h IS 'The presenters audit table.';
COMMENT ON COLUMN presenters_h.id IS 'The primary key for this audit table.';
COMMENT ON COLUMN presenters_h.log_op IS 'The operation on the modified row.';
COMMENT ON COLUMN presenters_h.log_time IS 'The timestamp for when this operation took place.';
COMMENT ON COLUMN presenters_h.presenter_id IS 'The primary key for the presenters row that was updated.';
COMMENT ON COLUMN presenters_h.name IS 'The full name of the presenter.';
COMMENT ON COLUMN presenters_h.biograhy IS 'A short professional biography about the presenter. ';
COMMENT ON COLUMN presenters_h.uidlog IS 'The id of the user or application that last changed this row.';
COMMENT ON COLUMN presenters_h.version IS 'The version number for this row.';
COMMENT ON COLUMN presenters_h.create_time IS 'The timestamp for when the presenters row was created.';
COMMENT ON COLUMN presenters_h.modify_time IS 'The timestamp for when the presenters row was modified.';

COMMENT ON SEQUENCE presenters_h_seq IS 'The sequence for the table presenters_h.';

COMMENT ON TRIGGER presenters_update_trigger ON presenters IS 'The audit trail update trigger for table presenters.';