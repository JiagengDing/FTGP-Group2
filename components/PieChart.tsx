import React from "react";
import { Pie } from "react-chartjs-2";

const PieChart = ({ data }) => {
	const chartData = {
		labels: ["DAI", "WBNB", "WETH"],
		datasets: [
			{
				data: data,
				backgroundColor: ["red", "blue", "green"],
			},
		],
	};

	return (
		<Pie
			data={chartData}
			options={{
				responsive: true,
				legend: {
					display: true,
					position: "bottom",
				},
			}}
		/>
	);
};

export default PieChart;
