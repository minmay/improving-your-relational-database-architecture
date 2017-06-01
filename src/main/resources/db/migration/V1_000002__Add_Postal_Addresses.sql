CREATE SEQUENCE postal_addresses_seq;

CREATE TABLE postal_addresses (
	id INTEGER PRIMARY KEY DEFAULT nextval('postal_addresses_seq'),
	street_or_po_box VARCHAR(255) CONSTRAINT postal_addresses_street_or_po_box_nn NOT NULL,
	city VARCHAR(100) CONSTRAINT postal_addresses_city_nn NOT NULL,
	principal_subdivision VARCHAR(50) CONSTRAINT postal_addresses_principal_subdivision_nn NOT NULL,
	postal_code VARCHAR(30) CONSTRAINT postal_addresses_country_nn NOT NULL,
	country VARCHAR(50),
	uidlog INTEGER NOT NULL DEFAULT 1,
	version INTEGER NOT NULL DEFAULT 1,
	create_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	modify_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

ALTER SEQUENCE postal_addresses_seq OWNED BY postal_addresses.id;

CREATE SEQUENCE postal_addresses_h_seq;

CREATE TABLE postal_addresses_h (
	id INTEGER PRIMARY KEY DEFAULT nextval('postal_addresses_h_seq'),
	log_op VARCHAR(50) NOT NULL,
	log_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  postal_address_id INTEGER NOT NULL,
  street_or_po_box VARCHAR(255) NOT NULL,
  city VARCHAR(100) NOT NULL,
  principal_subdivision VARCHAR(50) NOT NULL,
  postal_code VARCHAR(30) NOT NULL,
  country VARCHAR(50),
  uidlog INTEGER NOT NULL,
  version INTEGER NOT NULL,
  create_time TIMESTAMP NOT NULL,
  modify_time TIMESTAMP NOT NULL
);

ALTER SEQUENCE postal_addresses_seq OWNED BY postal_addresses_h.id;

CREATE TRIGGER postal_addresses_update_trigger
BEFORE UPDATE OR DELETE ON postal_addresses
    FOR EACH ROW EXECUTE PROCEDURE audit_update_trigger();

COMMENT ON SEQUENCE postal_addresses_seq IS 'The sequence for the table postal_addresses.';

COMMENT ON TABLE postal_addresses IS 'The postal address audit table.';
COMMENT ON COLUMN postal_addresses.id IS 'The primary key for this row.';
COMMENT ON COLUMN postal_addresses.street_or_po_box IS 'The street address or post office box number.';
COMMENT ON COLUMN postal_addresses.city IS 'The city or town name.';
COMMENT ON COLUMN postal_addresses.principal_subdivision IS 'Other principal subdivision (such as PROVINCE, STATE, COUNTY).';
COMMENT ON COLUMN postal_addresses.postal_code IS 'The postal code if known.';
COMMENT ON COLUMN postal_addresses.country IS 'The country name.  UPPERCASE letters in English.';
COMMENT ON COLUMN postal_addresses.uidlog IS 'The id of the user or application that last changed this row.';
COMMENT ON COLUMN postal_addresses.version IS 'The version number for this row.';
COMMENT ON COLUMN postal_addresses.create_time IS 'The timestamp for when this row was created.';
COMMENT ON COLUMN postal_addresses.modify_time IS 'The timestamp for when this row was modified.';

COMMENT ON SEQUENCE postal_addresses_h_seq IS 'The sequence for the table postal_addresses_h.';

COMMENT ON TABLE postal_addresses_h IS 'postal_addresses_h';
COMMENT ON COLUMN postal_addresses_h.id IS 'The primary key for this audit table.';
COMMENT ON COLUMN postal_addresses_h.log_op IS 'The operation on the modified row.';
COMMENT ON COLUMN postal_addresses_h.log_time IS 'The timestamp for when this operation took place.';
COMMENT ON COLUMN postal_addresses_h.postal_address_id IS 'The primary key for the xxxs row that was updated.';
COMMENT ON COLUMN postal_addresses_h.street_or_po_box IS 'The street address or post office box number.';
COMMENT ON COLUMN postal_addresses_h.city IS 'The city or town name.';
COMMENT ON COLUMN postal_addresses_h.principal_subdivision IS 'Other principal subdivision (such as PROVINCE, STATE, COUNTY).';
COMMENT ON COLUMN postal_addresses_h.postal_code IS 'The postal code if known.';
COMMENT ON COLUMN postal_addresses_h.country IS 'The country name.  UPPERCASE letters in English.';
COMMENT ON COLUMN postal_addresses_h.uidlog IS 'The id of the user or application that last changed this row.';
COMMENT ON COLUMN postal_addresses_h.version IS 'The version number for this row.';
COMMENT ON COLUMN postal_addresses_h.create_time IS 'The timestamp for when the xxxs row was created.';
COMMENT ON COLUMN postal_addresses_h.modify_time IS 'The timestamp for when the xxxs row was modified.';

COMMENT ON TRIGGER postal_addresses_update_trigger ON postal_addresses IS 'The audit trail update trigger for table postal_addresses.';
