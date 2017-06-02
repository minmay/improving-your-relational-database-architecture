package org.lajug.rdbms.jdbc;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

@SpringBootApplication
public class SeedProductsWithBatchApplication implements CommandLineRunner {

	private final static Logger logger = LoggerFactory.getLogger(SeedProductsWithBatchApplication.class);

	private DataSource dataSource;

	@Autowired
	public void setDataSource(DataSource dataSource) {
		this.dataSource = dataSource;
	}

	public static void main(String[] args) throws SQLException {
		SpringApplication.run(SeedProductsWithBatchApplication.class);
	}

	@Override
	public void run(String... strings) throws Exception {

		final long start_time = System.currentTimeMillis();
		logger.info("Starting batch at epoch time:  {}", start_time);

		batch();

		final long end_time = System.currentTimeMillis();
		final long elapsed_time = end_time - start_time;
		logger.info("batch elapsed time:  {}", elapsed_time);
		logger.info("That is 10000 + 20000 + 100000 = 130000 writes in {} ms", elapsed_time);
	}

	private void batch() throws SQLException {

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

				for (int i = 0; i < 10; i++) {
					final ResultSet products_seq = products_seq_stmt.executeQuery();
					final ResultSet options_seq = options_seq_stmt.executeQuery();
					while (products_seq.next()) {
						final long product_id = products_seq.getLong(1);

						insert_products_stmt.setLong(1, product_id);
						insert_products_stmt.setString(2, "T-Shirt #" + product_id);
						insert_products_stmt.addBatch();
						b++;

						final long color_option_id = insertOptions(insert_options_stmt, options_seq, product_id, "color");
						b++;
						insertOptionValues(insert_option_values_stmt, color_option_id, "white", "black", "red", "blue", "gray");
						b += 5;

						final long size_option_id = insertOptions(insert_options_stmt, options_seq, product_id, "size");
						b++;
						insertOptionValues(insert_option_values_stmt, size_option_id, "xs", "s", "m", "l", "xl");
						b += 5;


						if (b % 1300 == 0) {
							insert_products_stmt.executeBatch();
							insert_options_stmt.executeBatch();
							insert_option_values_stmt.executeBatch();
							c++;

							if (c % 10 == 0) {
								con.commit();
								System.out.println("Commit number:  " + c);
							}
						}
					}
				}

				if (b % 1300 != 0) {
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

	private void insertOptionValues(PreparedStatement insert_option_values_stmt, long option_id, String... values) throws SQLException {
		for (String value : values) {
			insert_option_values_stmt.setLong(1, option_id);
			insert_option_values_stmt.setString(2, value);
			insert_option_values_stmt.addBatch();
		}
	}

	private long insertOptions(PreparedStatement insert_options_stmt, ResultSet options_seq, long product_id, String name) throws SQLException {
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

	private Connection buildConnection() throws SQLException {
		final Connection con = dataSource.getConnection();
		return con;
	}


}
