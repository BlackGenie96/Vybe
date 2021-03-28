module.exports = app => {

    const users = require("../controllers/user.controller");

    let router = require("express").Router();

    //create user / register user
    router.post("/register", users.create);

    //update user category
    router.post("/update/category/:id", users.updateCategory);

    //user login 
    router.post("/login", users.login);

    //get user profile
    router.get("/profile/:id", users.getUser);

    //update user profile
    router.post("/update/:id", users.updateUser);

    app.use("/user", router);
}