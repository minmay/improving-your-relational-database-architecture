CREATE SEQUENCE presentations_seq;

CREATE TABLE presentations (
	id INTEGER PRIMARY KEY DEFAULT nextval ('presentations_seq'),
	presentation_date DATE NOT NULL,
	start_time TIME NOT NULL,
	postal_address_id INTEGER NOT NULL,
	hangout_url VARCHAR(255) NOT NULL,
	youtube_url VARCHAR(255) NOT NULL,
	slide_url VARCHAR(255) NOT NULL,
	topic VARCHAR(255) NOT NULL DEFAULT 'TBD',
	description TEXT NOT NULL,
	presenter_id INTEGER NOT NULL,
	company_id INTEGER,
	uidlog INTEGER NOT NULL DEFAULT 1,
	version INTEGER NOT NULL DEFAULT 1,
	create_time TIMESTAMP CONSTRAINT presentations_create_time_nn NOT NULL DEFAULT CURRENT_TIMESTAMP,
	modify_time TIMESTAMP CONSTRAINT presentations_modify_time_nn NOT NULL DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT presentations_presenter_id_fk FOREIGN KEY (presenter_id) REFERENCES presenters (id) ON DELETE CASCADE,
	CONSTRAINT presentations_company_id_fk FOREIGN KEY (company_id) REFERENCES companies (id) ON DELETE CASCADE
);

ALTER SEQUENCE presentations_seq OWNED BY presentations.id;

CREATE SEQUENCE presentations_h_seq;

CREATE TABLE presentations_h (
	id INTEGER PRIMARY KEY DEFAULT nextval('presentations_h_seq'),
	log_op VARCHAR(50) NOT NULL,
	log_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	presentation_id INTEGER NOT NULL,
	presentation_date DATE NOT NULL,
	start_time TIME NOT NULL,
	postal_address_id INTEGER NOT NULL,
	hangout_url VARCHAR(255) NOT NULL DEFAULT 'N/A',
	youtube_url VARCHAR(255) NOT NULL DEFAULT 'N/A',
	slide_url VARCHAR(255) NOT NULL  DEFAULT 'N/A',
	topic VARCHAR(255) NOT NULL DEFAULT 'TBD',
	description TEXT NOT NULL,
	presenter_id INTEGER NOT NULL,
	company_id INTEGER,
	uidlog INTEGER NOT NULL,
	version INTEGER NOT NULL,
	create_time TIMESTAMP NOT NULL,
	modify_time TIMESTAMP NOT NULL
);

ALTER SEQUENCE presentations_h_seq OWNED BY presentations_h.id;

CREATE TRIGGER presentations_update_trigger
BEFORE UPDATE OR DELETE ON presentations
    FOR EACH ROW EXECUTE PROCEDURE audit_update_trigger();

COMMENT ON SEQUENCE presentations_seq IS 'The sequence for the table presentations.';

COMMENT ON TABLE presentations IS 'presentations';
COMMENT ON COLUMN presentations.id IS 'The primary key for this row.';
COMMENT ON COLUMN presentations.presentation_date IS 'The date that the presentaion occurred, or will occur.';
COMMENT ON COLUMN presentations.start_time IS 'The time that the presentation will start.';
COMMENT ON COLUMN presentations.postal_address_id IS 'The foreign key of where the presentation will take place.';
COMMENT ON COLUMN presentations.hangout_url IS 'The Google Hangout URL for remote viewers.';
COMMENT ON COLUMN presentations.youtube_url IS 'The Youtube URL where the presentation will be archived.';
COMMENT ON COLUMN presentations.slide_url IS 'The URL where slides can be downloaded.';
COMMENT ON COLUMN presentations.topic IS 'The topic or name of this presentation';
COMMENT ON COLUMN presentations.description IS 'An abstract or description of the presentation.';
COMMENT ON COLUMN presentations.presenter_id IS 'The foreign key to the presentation information.';
COMMENT ON COLUMN presentations.company_id IS 'The foreign key to the company information.';
COMMENT ON COLUMN presentations.uidlog IS 'The id of the user or application that last changed this row.';
COMMENT ON COLUMN presentations.version IS 'The version number for this row.';
COMMENT ON COLUMN presentations.create_time IS 'The timestamp for when this row was created.';
COMMENT ON COLUMN presentations.modify_time IS 'The timestamp for when this row was modified.';

COMMENT ON TABLE presentations_h IS 'The presentations audit table.';
COMMENT ON COLUMN presentations_h.id IS 'The primary key for this audit table.';
COMMENT ON COLUMN presentations_h.log_op IS 'The operation on the modified row.';
COMMENT ON COLUMN presentations_h.log_time IS 'The timestamp for when this operation took place.';
COMMENT ON COLUMN presentations_h.presentation_id IS 'The primary key for the presentations row that was updated.';
COMMENT ON COLUMN presentations_h.presentation_date IS 'The date that the presentaion occurred, or will occur.';
COMMENT ON COLUMN presentations_h.start_time IS 'The time that the presentation will start.';
COMMENT ON COLUMN presentations_h.postal_address_id IS 'The foreign key of where the presentation will take place.';
COMMENT ON COLUMN presentations_h.hangout_url IS 'The Google Hangout URL for remote viewers.';
COMMENT ON COLUMN presentations_h.youtube_url IS 'The Youtube URL where the presentation will be archived.';
COMMENT ON COLUMN presentations_h.slide_url IS 'The URL where slides can be downloaded.';
COMMENT ON COLUMN presentations_h.topic IS 'The topic or name of this presentation';
COMMENT ON COLUMN presentations_h.description IS 'An abstract or description of the presentation.';
COMMENT ON COLUMN presentations_h.presenter_id IS 'The foreign key to the presentation information.';
COMMENT ON COLUMN presentations_h.company_id IS 'The foreign key to the company information.';
COMMENT ON COLUMN presentations_h.uidlog IS 'The id of the user or application that last changed this row.';
COMMENT ON COLUMN presentations_h.uidlog IS 'The id of the user or application that last changed this row.';
COMMENT ON COLUMN presentations_h.version IS 'The version number for this row.';
COMMENT ON COLUMN presentations_h.create_time IS 'The timestamp for when the presentations row was created.';
COMMENT ON COLUMN presentations_h.modify_time IS 'The timestamp for when the presentations row was modified.';

COMMENT ON SEQUENCE presentations_h_seq IS 'The sequence for the table presentations_h.';

COMMENT ON TRIGGER presentations_update_trigger ON presentations IS 'The audit trail update trigger for table presentations.';