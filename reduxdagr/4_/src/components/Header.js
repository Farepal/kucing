import { Link } from "react-router-dom";

const Header = () => {
    return (
        <header className="Header">
            <h1>Kontol</h1>
            <nav>
                <ul>
                    <li><Link to="/">Home</Link></li>
                    <li><Link to="/post">Add Post</Link></li>
                </ul>
            </nav>
        </header>
    )
}

export default Header