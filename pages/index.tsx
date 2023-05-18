import Image from "next/image";
import { Inter } from "next/font/google";
import Header from "../components/Header";

const inter = Inter({ subsets: ["latin"] });

export default function Home() {
	return (
		<div className=" min-h-screen text-white">
			<Header />

			<div className="flex justify-center">
				<div className="flex items-center justify-between pb-5">
					<div className="text-black py-5">
						<h2 className="text-5xl font-bold py-4 text-center">
							Trading Futures and Options <br /> in WEB 3.0
						</h2>

						<p className="text-2xl text-center">
							MANATEE is a highly secure and customisable <br /> futures and options decentralised
							trading platform.
						</p>
					</div>
				</div>
			</div>

			<main className="flex min-h-screen flex-col items-center justify-center p-24">
				<div className="mb-32 grid text-center lg:mb-0 lg:grid-cols-3 lg:text-left gap-10">
					<a
						href="/portfolio"
						className="group rounded-lg border border-transparent px-5 py-4 transition-colors hover:border-blue-700 hover:bg-blue-700/30 bg-blue-600 shadow-lg"
						target="_blank"
						rel="noopener noreferrer"
					>
						<h2 className={`${inter.className} mb-3 text-3xl font-semibold`}>
							Portfolio{" "}
							<span className="inline-block transition-transform group-hover:translate-x-1 motion-reduce:transform-none">
								-&gt;
							</span>
						</h2>
						<p className={`${inter.className} m-0 max-w-[30ch] text-lg opacity-75`}>
							Portfolio exchange.
						</p>
					</a>

					<a
						href="/options"
						className="group rounded-lg border border-transparent px-5 py-4 transition-colors hover:border-purple-700 hover:bg-purple-700/30 bg-purple-600 shadow-lg"
						target="_blank"
						rel="noopener noreferrer"
					>
						<h2 className={`${inter.className} mb-3 text-3xl font-semibold`}>
							Option{" "}
							<span className="inline-block transition-transform group-hover:translate-x-1 motion-reduce:transform-none">
								-&gt;
							</span>
						</h2>
						<p className={`${inter.className} m-0 max-w-[30ch] text-lg opacity-75`}>
							Options exchange.
						</p>
					</a>

					<a
						href="/futures"
						className="group rounded-lg border border-transparent px-5 py-4 transition-colors hover:border-purple-700 hover:bg-purple-700/30 bg-purple-600 shadow-lg"
						target="_blank"
						rel="noopener noreferrer"
					>
						<h2 className={`${inter.className} mb-3 text-3xl font-semibold`}>
							Future{" "}
							<span className="inline-block transition-transform group-hover:translate-x-1 motion-reduce:transform-none">
								-&gt;
							</span>
						</h2>
						<p className={`${inter.className} m-0 max-w-[30ch] text-lg opacity-75`}>
							Futures exchange.
						</p>
					</a>
				</div>
			</main>
		</div>
	);
}
