import * as React from "react";
import AppBar from "@mui/material/AppBar";
import Box from "@mui/material/Box";
import Toolbar from "@mui/material/Toolbar";
import IconButton from "@mui/material/IconButton";
import Typography from "@mui/material/Typography";
import Container from "@mui/material/Container";
import Button from "@mui/material/Button";
import MenuIcon from "@mui/icons-material/Menu";
import Drawer from "@mui/material/Drawer";
import List from "@mui/material/List";
import ListItem from "@mui/material/ListItem";
import ListItemText from "@mui/material/ListItemText";
import MetaMaskButton from "./MetaMaskButton";

function Header() {
	const [isDrawerOpen, setIsDrawerOpen] = React.useState(false);

	const toggleDrawer = (open) => () => {
		setIsDrawerOpen(open);
	};

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
						<IconButton
							color="inherit"
							edge="end"
							onClick={toggleDrawer(true)}
							sx={{ display: { md: "none" } }}
						>
							<MenuIcon />
						</IconButton>
						<Button
							variant="text"
							color="inherit"
							href="/blog"
							sx={{
								display: { xs: "none", md: "block" },
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
								display: { xs: "none", md: "block" },
								fontFamily: "monospace",
								fontWeight: 700,
								letterSpacing: ".3rem",
								mr: 2,
							}}
						>
							Guide
						</Button>
						<Button
							variant="text"
							color="inherit"
							href="/contact"
							sx={{
								display: { xs: "none", md: "block" },
								fontFamily: "monospace",
								fontWeight: 700,
								letterSpacing: ".3rem",
							}}
						>
							Contact
						</Button>
					</Box>
					<MetaMaskButton />

					<Drawer anchor="right" open={isDrawerOpen} onClose={toggleDrawer(false)}>
						<List>
							<ListItem button component="a" href="/blog">
								<ListItemText primary="Blog" />
							</ListItem>
							<ListItem button component="a" href="/guide">
								<ListItemText primary="Guide" />
							</ListItem>
							<ListItem button component="a" href="/contact">
								<ListItemText primary="Contact" />
							</ListItem>
						</List>
					</Drawer>
				</Toolbar>
			</Container>
		</AppBar>
	);
}

export default Header;
