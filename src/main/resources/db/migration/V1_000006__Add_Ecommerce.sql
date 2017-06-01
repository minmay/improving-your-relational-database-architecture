CREATE SEQUENCE products_seq;

CREATE TABLE products(
  id INTEGER PRIMARY KEY DEFAULT nextval('products_seq'),
  name VARCHAR(255) NOT NULL,
  uidlog INTEGER NOT NULL DEFAULT 1,
  version INTEGER NOT NULL DEFAULT 1,
  create_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  modify_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT products_name_uniq UNIQUE (name)
);

ALTER SEQUENCE products_seq OWNED BY products.id;

CREATE SEQUENCE products_h_seq;

CREATE TABLE products_h (
  id INTEGER PRIMARY KEY DEFAULT nextval('products_h_seq'),
  log_op VARCHAR(50) NOT NULL,
  log_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  product_id INTEGER NOT NULL,
  name VARCHAR(255) NOT NULL,
  uidlog INTEGER NOT NULL,
  version INTEGER NOT NULL,
  create_time TIMESTAMP NOT NULL,
  modify_time TIMESTAMP NOT NULL
);

ALTER SEQUENCE products_h_seq OWNED BY products_h.id;

CREATE TRIGGER products_update_trigger
BEFORE UPDATE OR DELETE ON products
FOR EACH ROW EXECUTE PROCEDURE audit_update_trigger();

COMMENT ON SEQUENCE products_seq IS 'The sequence for the table products.';

COMMENT ON TABLE products IS 'The products available in the system.';
COMMENT ON COLUMN products.id IS 'The primary key for this row.';
COMMENT ON COLUMN products.name IS 'The name of the product.';
COMMENT ON COLUMN products.uidlog IS 'The id of the user or application that last changed this row.';
COMMENT ON COLUMN products.version IS 'The version number for this row.';
COMMENT ON COLUMN products.create_time IS 'The timestamp for when this row was created.';
COMMENT ON COLUMN products.modify_time IS 'The timestamp for when this row was modified.';

COMMENT ON TABLE products_h IS 'The products audit table.';
COMMENT ON COLUMN products_h.id IS 'The primary key for this audit table.';
COMMENT ON COLUMN products_h.log_op IS 'The operation on the modified row.';
COMMENT ON COLUMN products_h.log_time IS 'The timestamp for when this operation took place.';
COMMENT ON COLUMN products_h.product_id IS 'The primary key for the products row that was updated.';
COMMENT ON COLUMN products_h.name IS 'The name of the product.';
COMMENT ON COLUMN products_h.uidlog IS 'The id of the user or application that last changed this row.';
COMMENT ON COLUMN products_h.version IS 'The version number for this row.';
COMMENT ON COLUMN products_h.create_time IS 'The timestamp for when the products row was created.';
COMMENT ON COLUMN products_h.modify_time IS 'The timestamp for when the products row was modified.';

COMMENT ON SEQUENCE products_h_seq IS 'The sequence for the table products_h.';

COMMENT ON TRIGGER products_update_trigger ON products IS 'The audit trail update trigger for table products.';

CREATE SEQUENCE options_seq;

CREATE TABLE options (
  id INTEGER PRIMARY KEY DEFAULT nextval('options_seq'),
  product_id INTEGER NOT NULL,
  name VARCHAR(255) NOT NULL,
  uidlog INTEGER NOT NULL DEFAULT 1,
  version INTEGER NOT NULL DEFAULT 1,
  create_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  modify_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT options_name_uniq UNIQUE (product_id, name),
  CONSTRAINT options_product_id_on_products_fk FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
);

ALTER SEQUENCE options_seq OWNED BY options.id;

CREATE SEQUENCE options_h_seq;

CREATE TABLE options_h (
  id INTEGER PRIMARY KEY DEFAULT nextval('options_h_seq'),
  log_op VARCHAR(50) NOT NULL,
  log_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  option_id INTEGER NOT NULL,
  product_id INTEGER NOT NULL,
  name VARCHAR(255) NOT NULL,
  uidlog INTEGER NOT NULL,
  version INTEGER NOT NULL,
  create_time TIMESTAMP NOT NULL,
  modify_time TIMESTAMP NOT NULL
);

ALTER SEQUENCE options_h_seq OWNED BY options_h.id;

CREATE TRIGGER options_update_trigger
BEFORE UPDATE OR DELETE ON options
FOR EACH ROW EXECUTE PROCEDURE audit_update_trigger();

COMMENT ON SEQUENCE options_seq IS 'The sequence for the table options.';

COMMENT ON TABLE options IS 'An option for a product.';
COMMENT ON COLUMN options.id IS 'The primary key for this row.';
COMMENT ON COLUMN options.product_id IS 'The foreign key to the products table.';
COMMENT ON COLUMN options.name IS 'The name of this option. It must be unique to a product. If there is a T-Shirt product, perhaps it will have two options: size, and color.';
COMMENT ON COLUMN options.uidlog IS 'The id of the user or application that last changed this row.';
COMMENT ON COLUMN options.version IS 'The version number for this row.';
COMMENT ON COLUMN options.create_time IS 'The timestamp for when this row was created.';
COMMENT ON COLUMN options.modify_time IS 'The timestamp for when this row was modified.';

COMMENT ON TABLE options_h IS 'The options audit table.';
COMMENT ON COLUMN options_h.id IS 'The primary key for this audit table.';
COMMENT ON COLUMN options_h.log_op IS 'The operation on the modified row.';
COMMENT ON COLUMN options_h.log_time IS 'The timestamp for when this operation took place.';
COMMENT ON COLUMN options_h.option_id IS 'The primary key for the options row that was updated.';
COMMENT ON COLUMN options_h.product_id IS 'The foreign key to the products table.';
COMMENT ON COLUMN options_h.name IS 'The name of this option. It must be unique to a product. If there is a T-Shirt product, perhaps it will have two options: size, and color.';
COMMENT ON COLUMN options_h.uidlog IS 'The id of the user or application that last changed this row.';
COMMENT ON COLUMN options_h.version IS 'The version number for this row.';
COMMENT ON COLUMN options_h.create_time IS 'The timestamp for when the options row was created.';
COMMENT ON COLUMN options_h.modify_time IS 'The timestamp for when the options row was modified.';

COMMENT ON SEQUENCE options_h_seq IS 'The sequence for the table options_h.';

COMMENT ON TRIGGER options_update_trigger ON options IS 'The audit trail update trigger for table options.';

CREATE SEQUENCE option_values_seq;

CREATE TABLE option_values (
  id INTEGER PRIMARY KEY DEFAULT nextval('option_values_seq'),
  option_id INTEGER NOT NULL,
  value VARCHAR(255) NOT NULL,
  uidlog INTEGER NOT NULL DEFAULT 1,
  version INTEGER NOT NULL DEFAULT 1,
  create_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  modify_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT option_values_value_uniq UNIQUE (option_id, value),
  CONSTRAINT option_values_option_id_on_options_fk FOREIGN KEY (option_id) REFERENCES options(id) ON DELETE CASCADE
);

ALTER SEQUENCE option_values_seq OWNED BY option_values.id;

CREATE SEQUENCE option_values_h_seq;

CREATE TABLE option_values_h (
  id INTEGER PRIMARY KEY DEFAULT nextval('option_values_h_seq'),
  log_op VARCHAR(50) NOT NULL,
  log_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  option_value_id INTEGER NOT NULL,
  option_id INTEGER NOT NULL,
  value VARCHAR(255) NOT NULL,
  uidlog INTEGER NOT NULL,
  version INTEGER NOT NULL,
  create_time TIMESTAMP NOT NULL,
  modify_time TIMESTAMP NOT NULL
);

ALTER SEQUENCE option_values_h_seq OWNED BY option_values_h.id;

CREATE TRIGGER option_values_update_trigger
BEFORE UPDATE OR DELETE ON option_values
FOR EACH ROW EXECUTE PROCEDURE audit_update_trigger();

COMMENT ON SEQUENCE option_values_seq IS 'The sequence for the table options.';

COMMENT ON TABLE option_values IS 'An association of possible values for an option.';
COMMENT ON COLUMN option_values.id IS 'The primary key for this row.';
COMMENT ON COLUMN option_values.option_id IS 'The option id that this row belongs to.';
COMMENT ON COLUMN option_values.value IS 'The value for this option. For example, for an option named "size", perhaps the option_values will have 5 rows with the values:  XS, S, M, L, XL.';
COMMENT ON COLUMN option_values.uidlog IS 'The id of the user or application that last changed this row.';
COMMENT ON COLUMN option_values.version IS 'The version number for this row.';
COMMENT ON COLUMN option_values.create_time IS 'The timestamp for when this row was created.';
COMMENT ON COLUMN option_values.modify_time IS 'The timestamp for when this row was modified.';

COMMENT ON TABLE option_values_h IS 'The option_values audit table.';
COMMENT ON COLUMN option_values_h.id IS 'The primary key for this audit table.';
COMMENT ON COLUMN option_values_h.log_op IS 'The operation on the modified row.';
COMMENT ON COLUMN option_values_h.log_time IS 'The timestamp for when this operation took place.';
COMMENT ON COLUMN option_values_h.option_value_id IS 'The primary key for the option_values row that was updated.';
COMMENT ON COLUMN option_values_h.option_id IS 'The option id that this row belongs to.';
COMMENT ON COLUMN option_values_h.value IS 'The value for this option. For example, for an option named "size", perhaps the option_values will have 5 rows with the values:  XS, S, M, L, XL.';
COMMENT ON COLUMN option_values_h.uidlog IS 'The id of the user or application that last changed this row.';
COMMENT ON COLUMN option_values_h.version IS 'The version number for this row.';
COMMENT ON COLUMN option_values_h.create_time IS 'The timestamp for when the option_values row was created.';
COMMENT ON COLUMN option_values_h.modify_time IS 'The timestamp for when the option_values row was modified.';

COMMENT ON SEQUENCE option_values_h_seq IS 'The sequence for the table option_values_h.';

COMMENT ON TRIGGER option_values_update_trigger ON option_values IS 'The audit trail update trigger for table option_values.';