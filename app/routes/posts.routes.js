module.exports = app => {


    const posts = require("../controllers/posts.controller");

    let router = require("express").Router();

    //create new post
    router.post("/create", posts.create);

    //get posts by category id
    router.get("/get/:id", posts.getPostByCategoryId);

    //get posts under a parent category from a list of subcategories
    router.get("/get", posts.getPostsFromList);

    //add post like
    router.put("/like/:post_id/:user_id", posts.addPostLike);

    //add post comment
    router.put("/comment", posts.addPostComment);

    app.use("/posts", router);
};