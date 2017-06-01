CREATE SEQUENCE companies_seq;

CREATE TABLE companies (
	id INTEGER PRIMARY KEY DEFAULT nextval ('companies_seq'),
	name VARCHAR(255) CONSTRAINT companies_name_nn NOT NULL,
	information TEXT,
	postal_address_id INTEGER CONSTRAINT companies_postal_address_id_nn NOT NULL,
	uidlog INTEGER CONSTRAINT companies_uidlog_nn NOT NULL DEFAULT 1,
	version INTEGER CONSTRAINT companies_version_nn NOT NULL DEFAULT 1,
	create_time TIMESTAMP CONSTRAINT companies_create_time_nn NOT NULL DEFAULT CURRENT_TIMESTAMP,
	modify_time TIMESTAMP CONSTRAINT companies_modify_time_nn NOT NULL DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT companies_postal_address_id_fk FOREIGN KEY (postal_address_id) REFERENCES postal_addresses (id) ON DELETE CASCADE
);

ALTER SEQUENCE companies_seq OWNED BY companies.id;

CREATE SEQUENCE companies_h_seq;

CREATE TABLE companies_h (
	id INTEGER PRIMARY KEY DEFAULT nextval('companies_h_seq'),
	log_op VARCHAR(50) CONSTRAINT companies_h_log_op_nn NOT NULL,
	log_time TIMESTAMP CONSTRAINT companies_h_log_time_nn NOT NULL DEFAULT CURRENT_TIMESTAMP,
	company_id INTEGER CONSTRAINT companies_h_company_id_nn NOT NULL,
	name VARCHAR(255) CONSTRAINT companies_h_name_nn NOT NULL,
	information TEXT,
	postal_address_id INTEGER CONSTRAINT companies_h_postal_address_id_nn NOT NULL,
	uidlog INTEGER CONSTRAINT companies_h_companie_uidlog_nn NOT NULL,
	version INTEGER CONSTRAINT companies_h_version_nn NOT NULL,
	create_time TIMESTAMP CONSTRAINT companies_h_create_time_nn NOT NULL,
	modify_time TIMESTAMP CONSTRAINT companies_h_modify_time_nn NOT NULL
);

ALTER SEQUENCE companies_h_seq OWNED BY companies_h.id;

CREATE TRIGGER companies_update_trigger
BEFORE UPDATE OR DELETE ON companies
    FOR EACH ROW EXECUTE PROCEDURE audit_update_trigger();

COMMENT ON SEQUENCE companies_seq IS 'The sequence for the table companies.';

COMMENT ON TABLE companies IS 'companies';
COMMENT ON COLUMN companies.id IS 'The primary key for this row.';
COMMENT ON COLUMN companies.name IS 'The name of the company.';
COMMENT ON COLUMN companies.information IS 'A description of the company.';
COMMENT ON COLUMN companies.postal_address_id IS 'The foreign key to the postal address.';
COMMENT ON COLUMN companies.uidlog IS 'The id of the user or application that last changed this row.';
COMMENT ON COLUMN companies.version IS 'The version number for this row.';
COMMENT ON COLUMN companies.create_time IS 'The timestamp for when this row was created.';
COMMENT ON COLUMN companies.modify_time IS 'The timestamp for when this row was modified.';

COMMENT ON TABLE companies_h IS 'The companies audit table.';
COMMENT ON COLUMN companies_h.id IS 'The primary key for this audit table.';
COMMENT ON COLUMN companies_h.log_op IS 'The operation on the modified row.';
COMMENT ON COLUMN companies_h.log_time IS 'The timestamp for when this operation took place.';
COMMENT ON COLUMN companies_h.company_id IS 'The primary key for the companies row that was updated.';
COMMENT ON COLUMN companies_h.name IS 'The name of the company.';
COMMENT ON COLUMN companies_h.information IS 'A description of the company.';
COMMENT ON COLUMN companies_h.postal_address_id IS 'The foreign key to the postal address.';
COMMENT ON COLUMN companies_h.uidlog IS 'The id of the user or application that last changed this row.';
COMMENT ON COLUMN companies_h.version IS 'The version number for this row.';
COMMENT ON COLUMN companies_h.create_time IS 'The timestamp for when the companies row was created.';
COMMENT ON COLUMN companies_h.modify_time IS 'The timestamp for when the companies row was modified.';

COMMENT ON SEQUENCE companies_h_seq IS 'The sequence for the table companies_h.';

COMMENT ON TRIGGER companies_update_trigger ON companies IS 'The audit trail update trigger for table companies.';