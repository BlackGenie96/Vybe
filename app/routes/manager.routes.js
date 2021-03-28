module.exports = app => {
    const managers = require("../controllers/manager.controller");
    let router = require("express").Router();

    //create new manager
    router.post("/register", managers.create);

    //update manager data
    router.post("/update/:id", managers.update);

    //get manager profile
    router.get("/profile/:id", managers.getProfile);

    //manager login
    router.post("/login", managers.login);

    app.use("/manager", router);
}