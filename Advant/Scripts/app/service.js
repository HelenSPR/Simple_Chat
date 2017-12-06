angular.module('ChatApp')
    .service('ChatSrv', ['$rootScope', function ChatService($rootScope) {
        var proxy = null;

        var initialize = function () {

            connection = $.hubConnection();
            this.proxy = connection.createHubProxy('NotificationHub');
            connection.start();

            //Publishing an event when server pushes a new message
            this.proxy.on('addNewMessageToPageD', function (date, user,message) {
                $rootScope.$emit("addNewMessageToPageD", date, user,message);
            });
        };

        var sendMessage = function (user, message) {
            this.proxy.invoke('send', message);
        };

        //return service object.
        return {
            initialize: initialize,
            sendMessage: sendMessage
        };
    }]);