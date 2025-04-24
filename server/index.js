const express = require('express');
const mongoose = require('mongoose');
const UserModel = require("./models/user");
const Room = require("./models/room");
const auth_middleware = require("./middleware/auth_middleware");
const cors = require("cors");

const auth = require("./routes/auth.js");
const roomRoutes = require("./routes/room.js");

const app = express();

//middlewares
app.use(cors());  // Move CORS middleware before other middleware
app.use(express.json());
app.use(auth);
app.use(roomRoutes);


app.get("/about",(req,res)=>{
    res.status(200).send("Made by MAYUR KUNDE");
});

const axios = require("axios");
const cheerio = require("cheerio");

// Endpoint: GET /api/leetcode/:username
app.get("/api/leetcode/:username", async (req, res) => {
  const { username } = req.params;
  const url = `https://leetcode-stats-api.herokuapp.com/${username}`;

  try {
    const response = await axios.get(url);
    const data = response.data;

    res.json({
      username,
      totalSolved: data.totalSolved,
      easySolved: data.easySolved,
      mediumSolved: data.mediumSolved,
      hardSolved: data.hardSolved,
    });
  } catch (error) {
    console.error("Error fetching data:", error.message);
    res.status(500).json({ error: "Failed to fetch LeetCode data" });
  }
});

// Endpoint: GET /api/gfg/:username
app.get("/api/gfg/:username", async (req, res) => {
    const { username } = req.params;
    const url = `https://geeks-for-geeks-stats-api.vercel.app/?raw=y&userName=${username}`;
  
    try {
      const response = await axios.get(url);
      const data = response.data;
      
      // Extract just the total problems solved
      const totalSolved = data.totalProblemsSolved || 0;
  
      res.json({
        username,
        totalSolved: totalSolved
      });
    } catch (error) {
      console.error("Error fetching GFG data:", error.message);
      res.status(500).json({ error: "Failed to fetch GeeksForGeeks data" });
    }
  });

// Endpoint: POST /api/update-links
app.post("/api/update-links", auth_middleware, async (req, res) => {
  try {
    const { email, leetcodelink, gfglink, codeforceslink, codecheflink } = req.body;
    
    const updatedUser = await UserModel.findOneAndUpdate(
      { email },
      { 
        leetcodelink: leetcodelink || "",
        gfglink: gfglink || "",
        codeforceslink: codeforceslink || "",
        codecheflink: codecheflink || ""
      },
      { new: true }
    ).select('-password'); // Exclude password from the response

    if (!updatedUser) {
      return res.status(404).json({ msg: "User not found" });
    }

    // Add token to response
    const userResponse = {
      ...updatedUser.toObject(),
      token: req.token,
      _id: updatedUser._id
    };

    res.json(userResponse);
  } catch (error) {
    console.error("Error updating links:", error.message);
    res.status(500).json({ error: "Failed to update links" });
  }
});

// Endpoint: POST /api/user/update-questions
app.post("/api/user/update-questions", auth_middleware, async (req, res) => {
  res.setHeader('Content-Type', 'application/json');
  try {
    const { userId, totalQuestions } = req.body;
    
    if (!userId) {
      return res.status(400).json({ msg: "User ID is required" });
    }

    // First update the user - use new keyword when creating ObjectId
    const updatedUser = await UserModel.findByIdAndUpdate(
      new mongoose.Types.ObjectId(userId),
      { totalQuestions },
      { new: true }
    ).select('-password');

    if (!updatedUser) {
      return res.status(404).json({ msg: "User not found" });
    }

    // Then update all rooms where this user is a member
    const rooms = await Room.find({ 'members.name': updatedUser.name });
    
    // Update each room
    const updatePromises = rooms.map(async (room) => {
      const memberIndex = room.members.findIndex(m => m.name === updatedUser.name);
      if (memberIndex !== -1) {
        room.members[memberIndex].totalQuestions = totalQuestions;
        await room.save();
      }
    });

    // Wait for all room updates to complete
    await Promise.all(updatePromises);

    res.json(updatedUser);
  } catch (error) {
    console.error("Error updating total questions:", error.message);
    res.status(500).json({ msg: "Error updating total questions" });
  }
});

//DB connectivity
const PORT=3000;

console.log("Starting Zodeb server...");

const DB='mongodb+srv://mayurkunde:mayur0785@zodebcluster.hcq6hjt.mongodb.net/?retryWrites=true&w=majority&appName=zodebCluster';

mongoose.connect(DB).then(()=>{
    console.log("Successfully connected to the database.");
    console.log("Server is live.");
}).catch((e)=>{console.log(e);});

//running our node server to PORT
app.listen(PORT,'0.0.0.0',()=>{
    console.log(`Listening to port ${PORT}`);
});
