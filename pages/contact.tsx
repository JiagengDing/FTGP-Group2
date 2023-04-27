import React from "react";
import Head from "next/head";
import { makeStyles } from "@material-ui/core/styles";
import { Typography, Link } from "@material-ui/core";
import Header from "../components/Header";

const useStyles = makeStyles((theme) => ({
	root: {
		display: "flex",
		flexDirection: "column",
		alignItems: "center",
		justifyContent: "center",
		height: "100vh",
		padding: theme.spacing(3),
	},
	title: {
		marginBottom: theme.spacing(3),
	},
	subtitle: {
		marginBottom: theme.spacing(2),
	},
}));

const contact = () => {
	const classes = useStyles();

	return (
		<div className={classes.root}>
			<Head>
				<title>Contact Us</title>
			</Head>
			<Typography variant="h4" className={classes.title}>
				Contact Us
			</Typography>
			<Typography variant="subtitle1" className={classes.subtitle}>
				We'd love to hear from you!
			</Typography>
			<Typography variant="body1">
				Please email us at <Link href="jiageng@mail.diing.uk">jiageng@mail.diing.uk</Link>.
			</Typography>
			<Typography variant="body2">
				You can also follow us on{" "}
				<Link href="https://github.com/jiagengding/ftgp-group2">GitHub</Link>.
			</Typography>
		</div>
	);
};

export default contact;
