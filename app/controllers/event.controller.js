const db = require("../models");
const Event = db.events;
const Post = db.posts;

//create new event
exports.create = (req, res) => {

    //validate inputs
    if(!req.body.manager_id){
        res.status(400).send({
            success: 0,
            message: "Required fields missing"
        });
        return;
    }

    //create new event from schema
    const event = new Event(req.body);
    event
        .save(event)
        .then(data => {
            if(!data){
                res.status(404).send({
                    success: 0, 
                    message: "Problem encountered while creating event profile."
                });
            }else{
                res.send({
                    success: 1,
                    message: "Successfully created event",
                    data: data
                });
            }
        })
        .catch(err => {
            res.status(500).send({
                success: 0,
                message: err.message || "Error creating event."
            });
        });
};

//add event rating
exports.addRating = (req, res) => {

    //validate inputs
    const event_id = req.params.event_id;
    const rating = req.params.rating;
    const user_id = req.params.user_id;

    if(!user_id && !rating && !event_id){
        res.status(400).send({
            success: 0,
            message: "Required fields missing."
        });
        return;
    }

    Event
        .findByIdAndUpdate(event_id,{ $push: {rating: {by: user_id, rate: rating}}},{useFindAndModify})
        .then(data => {
            if(!data){
                res.status(404).send({
                    success: 0,
                    message: "Error updating rating"
                });
            }else{
                res.send({
                    success: 1,
                    message: "Successfully added rating",
                    data: data
                });
            }
        })
        .catch(err => {
            res.status(500).send({
                success: 0,
                message: err.message || "Server error while updating rating for event."
            });
        });
};

//delete event
exports.deleteEvent = (req, res) => {

    //check for id
    const id = req.params.event_id;

    if(!id){
        res.status(400).send({
            success: 0,
            message: "Required fields missing"
        });
        return;
    }

    Event
        .findByIdAndRemove(id,{useFindAndModify})
        .then(data => {
            if(!data){
                res.status(404).send({
                    success: 0,
                    message: "Could not delete event with id: "+id
                });
                
            }else{
                res.send({
                    data: data,
                    success: 1,
                    message: "Event deleted successfully."
                });
            }
        })
        .catch(err => {

            res.status(500).send({
                success: 0,
                message: err.message || "Server error while deleting event"
            });
        }); 
};

//update event
exports.updateEvent = (req, res) => {

    //validate input
    const id = req.params.event_id;

    if(!id && !req.body){
        res.status(400).send({
           success: 0,
           message: "Required fields missing." 
        });
        return;
    }

    Event
        .findByIdAndUpdate(id,req.body,{useFindAndModify: false})
        .then(data =>{
            if(!data){
                res.status(404).send({
                    success: 0,
                    message: "Could not update event"
                });
            }else{
                res.send({
                    success: 1,
                    message: "Successfully updated event data",
                    data: data
                });
            }
        })
        .catch(err => {
            res.status(500).send({
                success: 0,
                message: err.message || "Server error when update event"
            });
        });
};

//get event created by manager with specified id
exports.getManagerEvents = (req, res) => {

    const id = req.params.manager_id;

    if(!id){
        res.status(400).send({
            success: 0, 
            message: "Required fields missing"
        });
        return;
    }

    let result = [];
    Event
        .find({manager: id})
        .populate("category", "-path -parent -has_children -createdAt -updatedAt")
        .then(data => {
            if(data instanceof Array){
                //events retrieved.
                //get the posts data from the Posts collection for each event
                for(let i=0; i < data.length; i++){
                    let temp = data[i];

                    let posts_num = 0;
                    let likes_num = 0;
                    let comments_num = 0;

                    Post
                        .find({post_about_event: temp._id},{likes:1, comments:1})
                        .then(data => {

                            if(data instanceof Array){
                                posts_num += data.length;
                                for(let j=0; j < data.length; j++){
                                    let postInfo = data[i];

                                    likes_num += postInfo.likes.length;
                                    comments_num += postInfo.comments.length;
                                }
                            }

                            return {posts: posts_num, likes: likes_num, comments: comments_num};
                        })
                        .then(val => {
                            //put required fields in the results Array
                            result.push({
                                "categoryId" : temp.category._id,
                                "categoryName": temp.category.name,
                                "eventId" : temp._id,
                                "postNum" : val.posts,
                                "postLikes" : val.likes,
                                "postComments": val.comments
                            });
                        })
                        .catch(err => {
                            res.status(500).send({
                                success: 0,
                                message: err.message || "Error getting post information"
                            });
                        });
                }

                res.send({
                    data:result,
                    success: 1,
                    message: "Successfully retrieved events"
                });

            }else if(!data){
                res.status(404).send({
                    success: 0,
                    message: "Error retrieving manager events",
                    data: data
                });
            }else{
                res.status(404).send({
                    success: 0,
                    message: "No array. Manager has no events",
                    data: data
                });
            }
        })
        .catch(err => {
            res.status(500).send({
                success: 0,
                message: err.message || "Server error while getting manager events"
            });
        });
};

//get event details using event id and manager id
exports.getEventProfile = (req, res) => {

    //validate inputs
    if(!req.body.event_id && !req.body.manager_id){
        res.status(400).send({
            success: 0,
            message: "Required fields missing"
        });
        return;
    }

    Event
        .findOne({_id : req.body.event_id, manager: req.body.manager_id})
        .populate("manager")
        .populate("category")
        .then(data => {
            if(!data){
                res.status(404).send({
                    success: 0,
                    message: "Could not find event"
                })
            }else{
                if(data.rating.length > 0){

                    let total = 0;
                    let len = data.rating.length;

                    for(let i=0; i < data.rating.length; i++){
                        total += data.rating[i].rate;
                    }

                    data.rating = null;
                    data.rating = total / len;
                }

                res.send({
                    success: 1,
                    message: "Successfully retrieved profile",
                    data: data
                });
            }
        })
        .catch(err => {
            res.status(500).send({
                success: 0,
                message: err.message || "Server error retrieving event details"
            });
        });
};


//get events by category id for display in the calendar activity
exports.getCalendarItems = (req, res) => {

    //validate input
    const cat_id = req.params.category_id;

    if(!cat_id){
        res.status(400).send({
            success: 0,
            message: "Required fields missing."
        });
        return;
    }

    Event
        .find({category: cat_id},{_id:1, name:1, date:1})
        .then(data => {
            if(!data){
                res.status(404).send({
                    success: 0, 
                    message: "No events found"
                });
            }else{
                res.send(data);
                console.log(data);
            }
        })
        .catch(err => {
            res.status(500).send({
                success: 0, 
                message: err.message || "Server error while getting calendar items."
            });
        });
};

//get event name list based on category
exports.getEventsList = (req, res) => {
    //validate input
    const category_id = req.params.category_id;

    if(!category_id){
        res.status(400).send({
            success: 0, 
            message: "Required fields missing"
        });
        return;
    }

    Event
        .find({category: category_id}, {_id: 1, name:1})
        .then(data => {
            if(!data || data.length == 0){
                res.status(404).send({
                    success: 0,
                    message: "No events found for selected category"
                });
            }else{
                res.send(data);
            }
        })
        .catch(err => {
            res.status(500).send({
                success: 0,
                message: err.message || "Server while retrieving event list"
            });
        });
};