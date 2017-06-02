package org.lajug.rdbms.jdbc;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

@Repository
public class NPlusOneAntiPattern {

	private final DataSource dataSource;

	@Autowired
	public NPlusOneAntiPattern(DataSource dataSource) {
		this.dataSource = dataSource;
	}

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

	private Connection buildConnection() throws SQLException {
		final Connection con = dataSource.getConnection();
		return con;
	}
}
