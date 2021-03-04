import consumer from "./consumer"

document.addEventListener('turbolinks:load', function() {

  if (document.getElementById("live-container")) {

    consumer.subscriptions.create("LiveChannel", {

      connected() {},

      disconnected() {},

      received(data) {
        var container = $("#live-container");
        var targetController = container.data("controller");
        if (!targetController || targetController == "" || targetController.toLowerCase() == data.controller.toLowerCase()) {
          container.children().last().remove();
          var log = $(data.log);
          container.prepend(log);
          log.addClass("live-highlight");
        }
      }

    });

  }

});