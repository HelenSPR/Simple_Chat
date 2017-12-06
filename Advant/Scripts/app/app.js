angular.module("ChatApp", [])
    .controller("ChatController", ['$scope', 'ChatSrv', '$rootScope', function ($scope, ChatSrv, $rootScope) {

        $scope.msg = {}
        $scope.messages = []

        $scope.init = function (Messages)
        {
            $scope.messages = Messages;
        }

        // send message button is clicked
        $scope.sendMessage = function (message, user) {
            if (message != '') {            
                ChatSrv.sendMessage(user, message);

                $scope.msg.Message = '';
                $("#message").focus();
            }
        }

        $("#message").focus();
        ChatSrv.initialize();

        //when the Chat Service broadcasts a addNewMessageToPageD
        $scope.$parent.$on('addNewMessageToPageD', function (e, date, user, message) {
            $scope.$apply(function () {
                //add this message to the current message list.
                return $scope.messages.push({
                    Id: '',
                    Date : date,
                    UserName: user,
                    Message: message,
                    UserId : ''
                })
            });
        });

    }]);