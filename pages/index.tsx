import Image from "next/image";
import { Inter } from "next/font/google";
import Header from "../components/Header";

const inter = Inter({ subsets: ["latin"] });

export default function Home() {
	return (
		<div>
			<Header />

			<div className="flex justify-center">
				<div className="flex items-center justify-between pb-5">
					<div className="text-black py-5">
						<h2 className="text-4xl font-bold py-4 ">
							Trading Futures and Options <br /> in WEB 3.0
						</h2>

						<p className="text-xl">
							MANATEE is a highly secure and customisable <br /> futures and options decentralised
							trading platform.
						</p>
					</div>
				</div>
			</div>

			<main className="flex min-h-screen flex-col items-center justify-between p-24">
				<div className="mb-32 grid text-center lg:mb-0 lg:grid-cols-2 lg:text-left">
					<a
						href="/options"
						className="group rounded-lg border border-transparent px-5 py-4 transition-colors hover:border-gray-300 hover:bg-gray-100 hover:dark:border-neutral-700 hover:dark:bg-neutral-800/30"
						target="_blank"
						rel="noopener noreferrer"
					>
						<h2 className={`${inter.className} mb-3 text-2xl font-semibold`}>
							Option{" "}
							<span className="inline-block transition-transform group-hover:translate-x-1 motion-reduce:transform-none">
								-&gt;
							</span>
						</h2>
						<p className={`${inter.className} m-0 max-w-[30ch] text-sm opacity-50`}>
							Options exchange.
						</p>
					</a>

					<a
						href="/futures"
						className="group rounded-lg border border-transparent px-5 py-4 transition-colors hover:border-gray-300 hover:bg-gray-100 hover:dark:border-neutral-700 hover:dark:bg-neutral-800/30"
						target="_blank"
						rel="noopener noreferrer"
					>
						<h2 className={`${inter.className} mb-3 text-2xl font-semibold`}>
							Future{" "}
							<span className="inline-block transition-transform group-hover:translate-x-1 motion-reduce:transform-none">
								-&gt;
							</span>
						</h2>
						<p className={`${inter.className} m-0 max-w-[30ch] text-sm opacity-50`}>
							Futures exchange.
						</p>
					</a>
				</div>
			</main>
		</div>
	);
}
