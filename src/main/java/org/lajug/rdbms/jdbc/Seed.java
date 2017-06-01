package org.lajug.rdbms.jdbc;

import java.sql.*;
import java.util.Properties;

public class Seed {


	public void nPlusOne() throws SQLException {
		try (Connection con = buildConnection()) {
			PreparedStatement p = con.prepareStatement("SELECT id, name FROM products");
			ResultSet prs = p.executeQuery();
			while(prs.next()) {
				PreparedStatement o = con.prepareStatement("SELECT id, name FROM options WHERE product_id = ?");
				o.setLong(1, prs.getLong(1));
				ResultSet ors = o.executeQuery();
				while(ors.next()) {
					long option_id = ors.getLong(1); //remaining business logic ...
				}
			}
		}
	}

	public void batch() throws SQLException {

		final long start_ms = System.currentTimeMillis();
		try (final Connection con = buildConnection()) {

			con.setAutoCommit(false);
			try (
					PreparedStatement seq = con.prepareStatement("SELECT nextval('products_seq') FROM generate_series(1, 1000)");
					PreparedStatement insert = con.prepareStatement("INSERT INTO products(id, name) VALUES(?, ?)");
			) {
				int b = 0;
				int c = 0;

				for (int i = 0; i < 1000; i++) {
					final ResultSet products_seq = seq.executeQuery();
					while (products_seq.next()) {

						long product_id = products_seq.getLong(1);
						insert.setLong(1, product_id);
						insert.setString(2, "T-Shirt #" + product_id);
						insert.addBatch(); b++;

						if (b % 100 == 0) { insert.executeBatch(); c++; }

						if (c % 10 == 0) { con.commit(); }
					}
				}

				if (b % 100 != 0) { insert.executeBatch(); }

				if (c % 10 != 0) { con.commit(); }

			}
		}
		final long end_ms = System.currentTimeMillis();
		System.out.println("Elapsed time:  " + (end_ms - start_ms));
	}

	public void execute() throws SQLException {

		final long start_ms = System.currentTimeMillis();
		try (final Connection con = buildConnection()) {

			con.setAutoCommit(false);
			try (
					final PreparedStatement products_seq_stmt = con.prepareStatement("SELECT nextval('products_seq') FROM generate_series(1, 1000)");
					final PreparedStatement insert_products_stmt = con.prepareStatement("INSERT INTO products(id, name) VALUES(?, ?)");

					final PreparedStatement options_seq_stmt = con.prepareStatement("SELECT nextval('options_seq') FROM generate_series(1, 2000)");
					final PreparedStatement insert_options_stmt = con.prepareStatement("INSERT INTO options(id, product_id, name) VALUES(?, ?, ?)");

					final PreparedStatement insert_option_values_stmt = con.prepareStatement("INSERT INTO option_values(option_id, value) VALUES(?, ?)");
			) {
				int b = 0;
				int c = 0;

				for (int i = 0; i < 1000; i++) {
					final ResultSet products_seq = products_seq_stmt.executeQuery();
					final ResultSet options_seq = options_seq_stmt.executeQuery();
					while (products_seq.next()) {
						final long product_id = products_seq.getLong(1);

						insert_products_stmt.setLong(1, product_id);
						insert_products_stmt.setString(2, "T-Shirt #" + product_id);
						insert_products_stmt.addBatch();
						b++;

						final long color_option_id = insert_options(insert_options_stmt, options_seq, product_id, "color");
						b++;
						insert_option_values(insert_option_values_stmt, color_option_id, "white", "black", "red", "blue", "gray");
						b += 5;

						final long size_option_id = insert_options(insert_options_stmt, options_seq, product_id, "size");
						b++;
						insert_option_values(insert_option_values_stmt, size_option_id, "xs", "s", "m", "l", "xl");
						b += 5;


						if (b % 130 == 0) {
							insert_products_stmt.executeBatch();
							insert_options_stmt.executeBatch();
							insert_option_values_stmt.executeBatch();
							c++;
						}

						if (c % 10 == 0) {
							con.commit();
							System.out.println("Commit number:  " + c);
						}
					}
				}

				if (b % 130 != 0) {
					insert_products_stmt.executeBatch();
					insert_options_stmt.executeBatch();
					insert_option_values_stmt.executeBatch();
				}

				if (c % 10 != 0) {
					con.commit();
				}

			}
		}
		final long end_ms = System.currentTimeMillis();
		System.out.println("Elapsed time:  " + (end_ms - start_ms));
	}

	private void insert_option_values(PreparedStatement insert_option_values_stmt, long option_id, String... values) throws SQLException {
		for (String value : values) {
			insert_option_values_stmt.setLong(1, option_id);
			insert_option_values_stmt.setString(2, value);
			insert_option_values_stmt.addBatch();
		}
	}

	private long insert_options(PreparedStatement insert_options_stmt, ResultSet options_seq, long product_id, String name) throws SQLException {
		if (options_seq.next()) {
			final long color_option_id = options_seq.getLong(1);
			insert_options_stmt.setLong(1, color_option_id);
			insert_options_stmt.setLong(2, product_id);
			insert_options_stmt.setString(3, name);
			insert_options_stmt.addBatch();
			return color_option_id;
		} else {
			throw new IllegalStateException("Fell out of sequence.");
		}
	}

	public static void main(String[] args) throws SQLException {
		Seed seed = new Seed();
		seed.execute();
	}

	private Connection buildConnection() throws SQLException {
		final String url = "jdbc:postgresql://galaxy:5432/lajug";
		final Properties props = new Properties();
		props.setProperty("user", "lajug");
		props.setProperty("password", "lajug");
		final Connection con = DriverManager.getConnection(url, props);
		return con;
	}
}
