module.exports = app => {

    const events = require("../controllers/event.controller");
    let router = require("express").Router();

    //create new event
    router.post("/create", events.create);

    //add event rating
    router.put("/rate/:event_id/:rating/:user_id", events.addRating);

    //delete event
    router.delete("/delete/:event_id", events.deleteEvent);

    //update event
    router.post("/update/:event_id", events.updateEvent);

    //get manager events
    router.get("/manager/:manager_id", events.getManagerEvents);

    //get event profile
    router.post("/profile", events.getEventProfile);

    //get calendar elements
    router.get("/calendar/:category_id", events.getCalendarItems);

    //get events list
    router.get("/list/:category_id", events.getEventsList);

    app.use("/event", router);
};