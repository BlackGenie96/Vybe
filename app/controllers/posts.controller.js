const db = require("../models");
const Post = db.posts;

//create post
exports.create = (req, res) => {

    //validate content
    if(!req.body){
        res.status(400).send({
            success: 0,
            message: "Required fields missing"
        });
        return;
    }

    const post = new Post(req.body);
    console.log(post);

    post.save(post)
        .then(data => {
            console.log(data);
            res.send(data);
        })
        .catch(err => {
            res.status(500).send({
                success: 0,
                message: err.message || "Error creating post"
            });
        });
};

//retrieve post for feed based on category id
exports.getPostByCategoryId = (req, res) => {

    const id = req.params.id;

    if(!id){
        res.status(400).send({
            success: 0,
            message: "Required fields missing"
        });
        return;
    }

    Post
        .find({category: id})
        .populate("category", "-path -__v -createdAt -updatedAt")
        .populate("post_by_user", " -__v -email -phone -password -current_category -createdAt -updatedAt")
        .populate("post_by_mananger", "-__v -email -phone -password -payment -createdAt -updatedAt")
        .populate("post_about_business", "-__v -address -phone_number -image -rating -latitude -longitude -website -about -directions -category -createdAt -updatedAt")
        .populate("post_about_event", "")
        .then(data =>{

            if(!data){
                res.send({
                    success: 0,
                    message: "No Posts Found"
                });
            }else{
                
                if(data instanceof Array){
                    for(let i=0; i < data.length; i++){

                        //change likes from array to length of the array
                        data[i].likes = data[i].likes.length;
                        data[i].comments = data[i].comments.length;

                        console.log(data[i]);
                    }

                    res.send(data);
                }else{
                    res.status(404).send({
                        success: 0,
                        message: "Data retrieved not array. Error."
                    });
                }
            }
        })
        .catch(err => {
            res.status(500).send({
               success: 0,
               message: err.message || "Error occured getting posts for category id: "+id 
            });
        });
};

//get posts using a list of categories under a parent
exports.getPostsFromList = (req, res) => {

    //validate input
    if(!req.body instanceof Array){
        res.status(400).send({
            success: 0,
            message: "Required fields missing"
        });
        return;
    }

    //initialize result array
    let result = [];

    for(let i=0; i < req.body.length; i++){
        let temp = req.body[i];

        Post.find({category: temp._id})
            .populate("category", "-path -__v -createdAt -updatedAt")
            .populate("post_by_user", "-email -phone -password -current_category -createdAt -updatedAt")
            .populate("post_by_mananger", "-email -phone -password -payment -createdAt -updatedAt")
            .populate("post_about_business", "-address -phone_number -image -rating -latitude -longitude -website -about -directions -category -createdAt -updatedAt")    
            .then(data => {
                
                for(let j=0; j < data.length; j++){
                    data[j] = data[j].likes.length;
                    data[j] = data[j].comments.length;
                }

                result.push(data);
                console.log(data);
            })
            .catch(err => {
                console.log(err.message);
            });
    }

    res.send(result);
};

//add like by user id
exports.addPostLike = (req, res) => {

    const user_id = req.params.user_id;
    const post_id = req.params.post_id;

    if(!user_id && !post_id) {
        res.status(400).send({
            success: 0,
            message: "Required fields missing"
        });
        return;
    }

    //find the post if it exists
    Post.findById(post_id)
        .then(data => {
            
            const post = data;
            //check in likes array if the user id exists
            if(post.likes.includes(user_id)){
                //like exists, remove from the list
                let index = post.likes.indexOf(user_id);
                post.likes.splice(index, 1);
                res.send({
                    success: 1,
                    message: "Removed like successfully"
                });
            }else{
                //like does not exist in the likes array
                post.likes.push(user_id);
                post.save(post);
                res.send({
                    success: 1,
                    message: "Added like successfully to post"
                });
            }
        })
        .catch(err => {
            res.status(500).send({
                success: 0,
                message: err.message || "Error adding post like"
            });
        });
};

//add comment using user id or manager id
exports.addPostComment = (req, res) => {

    //validate input data
    if(!req.body.comments && !req.body.post_id){
        res.status(400).send({
            success: 0,
            message: "Required fields missing"
        });
        return;
    }

    Post.findByIdAndUpdate(req.body.post_id, {$push: {comments: req.body.comments}},{useFindAndModify: false})
        .then(data => {
            if(!data){
                res.status(404).send({
                    success: 0,
                    message: "Could not add comments to post"
                });
            }else{
                res.send({
                    success: 1,
                    message: "Successfully added comment"
                });
            }
        });
};

//get specific event posts
exports.getEventPosts = (req, res) => {

    //event id
    const event_id = req.params.event_id;

    if(!event_id){
        res.status(400).send({
            success: 0, 
            message: "Required fields missing"
        });
        return;
    }

    Post
        .find({post_about_event: event_id})
        .then(data => {
            if(!data){
                res.status(404).send({
                    success: 0,
                    message: "Error retrieving event posts. None were found for this event",
                    data: data
                });
            }else{
                res.send({
                    success: 1,
                    message: "Successfully retrieved event posts",
                    data: data
                });
            }
        })
        .catch(err => {
            res.status(500).send({
                success: 0,
                message: err.message || "Server error while getting event posts"
            });
        });
};

//get specific business posts
exports.getBusinessPosts = (req, res) => {
    //validate input
    const business_id = req.params.business_id;

    if(!business_id){
        res.status(400).send({
            success: 0,
            message: "Required fields missing"
        });
        return;
    }

    Post
        .find({post_about_business})
        .then(data => {
            if(!data){
                res.status(404).send({
                    success: 0,
                    message: "No posts about the business",
                    data: data
                });
            }else{
                res.send({
                    success: 1,
                    message: "Successfully retrieved business posts",
                    data: data
                });
            }
        })
        .catch(err => {
            res.status(500).send({
                success: 0,
                message: err.message || "Server error while retrieving posts data"
            });
        });
};