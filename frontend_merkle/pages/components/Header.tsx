import Image from 'next/image'

function Header() {
    return <header>
            <nav className="max-w-full lg:pt-1 bg-black">
                <div className="grid grid-rows-12 grid-flow-col">
                    <div className='justify-front flex'>
                    </div>
                    <div className="lg:justify-center flex">
                    </div>
                    <div className="justify-end px-2 flex">
                        <div className="bg-[url('/opensea_icon.png')] invisible md:visible px-2 pt-8 mx-1 bg-center bg-cover"><a className="px-2 py-4" href="https://opensea.io/ja/collection/cnpes-generative"></a></div>
                        <div className="bg-[url('/twitter_icon.png')] invisible md:visible px-2 pt-8 mx-1 bg-center bg-cover"><a className="px-2 py-4" href="https://twitter.com/CNPEnjoySports"></a></div>
                    </div>
                </div>
            </nav>
        </header>
}

export default Header;