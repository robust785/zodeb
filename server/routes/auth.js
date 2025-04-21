const express=require("express");
const jwt=require("jsonwebtoken");
const UserModel = require("../models/user");
const auth_middleware = require("../middleware/auth_middleware");

const authRouter=express.Router();

authRouter.post('/api/signup',async(req,res)=>{ //request=user provides and response=server returns.
    try{

        //GET DATA FROM CLIENT
        const {name,email,password,photo,leetcodelink,gfglink,codeforceslink,codecheflink,type} =req.body;
        //before posting data into Db we have to validate the data (like is email valid)
        const existingUser=await UserModel.findOne({email:email});
        if(existingUser)
            {
                return res.status(400).json({msg:"User with same email already exist."});
            }
            
       
            //POST DATA IN DB
            
            let user=new UserModel({name,email,password,photo,leetcodelink,gfglink,codeforceslink,codecheflink,type});
            user=await user.save();
            
            //RETURN SUCCESS MSG   
            res.json(user); 
        }catch(e)
        {
            res.status(500).json({error:e.message});
        }
    });



    // //login shit
    authRouter.post('/api/login',async(req,res)=>{
    
        try{
            const {email,password}=req.body;
            
            //first check whether the user exist
            const user= await UserModel.findOne({email:email});
            if(!user)
            {
                return res.status(400).json({msg:"User does not exist."});        
            }
            
            //if exist then match the password
            //const flag=await bcryptjs.compare(password,user.password);
            if(user.password!=password)
            {
                return res.status(400).json({msg:"Incorrect Password"});        
                    
            }
            
            //finally signin the user
            const token= jwt.sign({id: user._id},"passwordKey");
            res.json({token, ...user._doc});
            
        
        }catch(e)
        {
            res.status(500).json({error:e.message});
        }
    });
    

     //validating the token for state persistence ( getUserData() )
    authRouter.post('/tokenIsValid',async(req,res)=>{
        
        try{
            //get the token
            const token=req.header("x-auth-token");

            //if token =null then return false
            if(!token) return res.json(false);

            //if token is there, validate it
            const validated=jwt.verify(token,"passwordKey");
            if(!validated) return res.json(false);

            //even if the token came valid, check whether it is there in the database or not.
            const user=await UserModel.findById(validated.id);
            if(!user) return res.json(false);


            
            //if token is valid then fetch the user data and return it to the client.
            res.json(true);
            


        }catch(e)
        {
            res.status(500).json({error:e.message});
        }
    });
    
    authRouter.get("/", auth_middleware, async (req, res) => {
        try {
        
        const user = await UserModel.findById(req.user);
        
        if (!user) {
            return res.status(404).json({ message: "User not found" });
        }
    
          // Exclude sensitive fields
          //const { password, __v, ...userData } = user._doc;

        res.json({ ...user._doc,token:req.token });
        } catch (error) {
        console.error("Error in getUserData:", error);
        res.status(500).json({ message: "Internal server error" });
        }
    });



    

module.exports =authRouter;

