import * as React from "react";
import AppBar from "@mui/material/AppBar";
import Box from "@mui/material/Box";
import Toolbar from "@mui/material/Toolbar";
import IconButton from "@mui/material/IconButton";
import Typography from "@mui/material/Typography";
import Container from "@mui/material/Container";
import Button from "@mui/material/Button";
import MetaMaskButton from "./MetaMaskButton";

function Header() {
	return (
		<AppBar position="static">
			<Container maxWidth="xl">
				<Toolbar sx={{ justifyContent: "space-between" }}>
					<Box sx={{ display: "flex", alignItems: "center" }}>
						<Typography
							variant="h6"
							noWrap
							component="a"
							href="/"
							sx={{
								ml: 1,
								fontFamily: "monospace",
								fontWeight: 700,
								letterSpacing: ".3rem",
								color: "inherit",
								textDecoration: "none",
							}}
						>
							MANATEE
						</Typography>
					</Box>
					<Box sx={{ display: "flex", alignItems: "center" }}>
						<Button
							variant="text"
							color="inherit"
							href="/blog"
							sx={{
								fontFamily: "monospace",
								fontWeight: 700,
								letterSpacing: ".3rem",
								mr: 2,
							}}
						>
							Blog
						</Button>

						<Button
							variant="text"
							color="inherit"
							href="/guide"
							sx={{
								fontFamily: "monospace",
								fontWeight: 700,
								letterSpacing: ".3rem",
							}}
						>
							Guide
						</Button>

						<Button
							variant="text"
							color="inherit"
							href="/contact"
							sx={{
								fontFamily: "monospace",
								fontWeight: 700,
								letterSpacing: ".3rem",
							}}
						>
							Contact
						</Button>
					</Box>

					<MetaMaskButton />
				</Toolbar>
			</Container>
		</AppBar>
	);
}

export default Header;
