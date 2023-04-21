import React from "react";
import AppBar from "@material-ui/core/AppBar";
import Toolbar from "@material-ui/core/Toolbar";
import Typography from "@mui/material/Typography";
import MetaMaskButton from "./MetaMaskButton";
import Link from "next/link";

const Header = () => {
	return (
		<AppBar position="static">
			<Toolbar>
				<Typography variant="h6" component="div" sx={{ flexGrow: 1 }}>
					My App
					<Link href="/blog"> Blog </Link>
					<Link href="/about"> About </Link>
				</Typography>

				<MetaMaskButton />
			</Toolbar>
		</AppBar>
	);
};

export default Header;
