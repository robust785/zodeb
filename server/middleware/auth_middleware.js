
const jwt = require("jsonwebtoken");

const auth_middleware = (req, res, next) => {
try {
    const token = req.header("x-auth-token");

    if (!token) {
         return res.status(401).json({ msg: "Token does not exist. Access denied." });
    }
    
    //RR used const verified=
    const decoded = jwt.verify(token, "passwordKey");
    if(!decoded)
    {
      return res.status(401).json({ msg: "token verification failed" });   
    }
    req.user = decoded.id;
    req.token = token;
    
    
    next();  // This will pass control to the callback function
  } catch (err) {
    if (err instanceof jwt.JsonWebTokenError) {
      return res.status(401).json({ msg: "Invalid token" });
    }
    console.error("Auth middleware error:", err);
    res.status(500).json({ error: "Internal server error" });
  }
};

module.exports = auth_middleware;