const express = require('express');
const Room = require('../models/room');
const UserModel = require('../models/user');
const router = express.Router();

// Create a new room
router.post('/api/room/create', async (req, res) => {
    try {
        const { name, createdBy } = req.body;
        
        if (!name || !createdBy) {
            return res.status(400).json({ msg: 'Room name and creator are required' });
        }

        let room = await Room.findOne({ name });
        if (room) {
            return res.status(400).json({ msg: 'Room with this name already exists' });
        }

        // Get creator's totalQuestions
        const creator = await UserModel.findOne({ name: createdBy });
        if (!creator) {
            return res.status(404).json({ msg: 'Creator not found' });
        }

        room = new Room({
            name: name.trim(),
            createdBy,
            members: [{ name: createdBy, totalQuestions: creator.totalQuestions || 0 }]
        });

        room = await room.save();
        res.json(room);
    } catch (e) {
        console.error('Error creating room:', e);
        res.status(500).json({ msg: 'Failed to create room' });
    }
});

// Join a room
router.post('/api/room/join', async (req, res) => {
    try {
        const { name, memberName } = req.body;
        
        const room = await Room.findOne({ name });
        if (!room) {
            return res.status(404).json({ msg: 'Room not found' });
        }

        // Check if member already exists
        const memberExists = room.members.some(member => member.name === memberName);
        if (memberExists) {
            return res.status(400).json({ msg: 'You are already a member of this room' });
        }

        // Get member's totalQuestions
        const member = await UserModel.findOne({ name: memberName });
        if (!member) {
            return res.status(404).json({ msg: 'Member not found' });
        }

        room.members.push({ 
            name: memberName, 
            totalQuestions: member.totalQuestions || 0 
        });
        await room.save();
        res.json(room);
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

// Get all rooms
router.get('/api/rooms', async (req, res) => {
    try {
        const rooms = await Room.find();
        res.json(rooms);
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

// Get room by name
router.get('/api/room/:name', async (req, res) => {
    try {
        const room = await Room.findOne({ name: req.params.name });
        if (!room) {
            return res.status(404).json({ msg: 'Room not found' });
        }
        res.json(room);
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

// Update member's question count
router.put('/api/room/update-questions', async (req, res) => {
    try {
        const { roomName, memberName, totalQuestions } = req.body;
        
        const room = await Room.findOne({ name: roomName });
        if (!room) {
            return res.status(404).json({ msg: 'Room not found' });
        }

        const memberIndex = room.members.findIndex(m => m.name === memberName);
        if (memberIndex === -1) {
            return res.status(404).json({ msg: 'Member not found in room' });
        }

        // Update member's totalQuestions
        room.members[memberIndex].totalQuestions = totalQuestions;
        await room.save();
        res.json(room);
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

// Remove member from room
router.delete('/api/room/remove-member', async (req, res) => {
    try {
        const { roomName, memberName, creatorName } = req.body;
        
        const room = await Room.findOne({ name: roomName });
        if (!room) {
            return res.status(404).json({ msg: 'Room not found' });
        }

        // Verify if the request is made by the room creator
        if (room.createdBy !== creatorName) {
            return res.status(403).json({ msg: 'Only room creator can remove members' });
        }

        // Don't allow removing the creator
        if (memberName === creatorName) {
            return res.status(400).json({ msg: 'Cannot remove the room creator' });
        }

        // Remove the member
        room.members = room.members.filter(member => member.name !== memberName);
        await room.save();
        
        res.json(room);
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

// Get user's rooms
router.get('/api/rooms/:userName', async (req, res) => {
    try {
        const userName = req.params.userName;
        const rooms = await Room.find({
            $or: [
                { createdBy: userName },
                { 'members.name': userName }
            ]
        });
        res.json({ rooms });
    } catch (e) {
        console.error('Error fetching rooms:', e);
        res.status(500).json({ msg: 'Failed to fetch rooms' });
    }
});

module.exports = router;