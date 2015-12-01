"use strict";
exports = module.exports = function(server){
  var ERR = require('node-restify-errors');
  var moment = require('moment');

/**
 * @api {post} /forum/pm/:id SendUserPM
 * @apiName SendUserPM
 * @apiGroup Forum
 * @apiHeader {String} auth Votre cookie de connexion.
 * @apiParam {Integer} id Un identifiant unique correspondant à l'userID forum.
 * @apiParam {String} title Le titre du message à envoyer
 * @apiParam {String} message Le message en lui même.
 */
/*

*/
server.post('/forum/pm/:id', function (req, res, next) {
  if( req.params['id'] == 0 )
    return res.send(new ERR.BadRequestError("InvalidParam"));
  server.conn.query(server.getAuthSteamID, [req.headers.auth], function(err, row) {
    if( row.length == 0 ) throw "NotAuthorized";
    var uid = row[0].user_id;

    var sql = "INSERT INTO `ts-x`.`phpbb3_privmsgs`(`msg_id`, `author_id`, `author_ip`, `message_time`, `message_subject`, `message_text`, `to_address` ) VALUES";
    sql += "  (NULL, '"+uid+"', '0.0.0.0', UNIX_TIMESTAMP(), ?, ?, 'u_"+req.params['id']+"');"
    server.conn.query(sql, [req.params['title'], req.params['message']], function(err, row) {
      var ID = row.insertId;

      sql = "INSERT INTO `ts-x`.`phpbb3_privmsgs_to`(`msg_id`, `user_id`, `author_id`, `pm_new`, `pm_unread`) VALUES ";
      sql += " (?, ?, ?, '1', '1');"
      server.conn.query(sql, [ID, req.params['id'], uid], function(err, row) {
        sql = "UPDATE `ts-x`.`phpbb3_users` SET `user_new_privmsg`=`user_new_privmsg`+1, `user_unread_privmsg`=`user_unread_privmsg`+1, `user_last_privmsg`=UNIX_TIMESTAMP() WHERE `user_id`=?";
        server.conn.query(sql, [req.params['id']], function(err, row) {
          return res.send("OK");
        });
      });
    });
  });
  next();
});
};