<h2>{{data.name}} <span ng-class="connected?'text-success':'text-danger'"><i class="fa fa-gamepad"></i></span></h2>
<div class="row" style="position:relative;">
  <div class="col-sm-4">
    <div draw-line="right,150,15" class="box">
      <span ng-show="data.job_id > 0">Job: <a href="#/job/{{(data.job_id - (data.job_id % 10))+1}}">{{data.job_name}}</a> depuis {{Math.round(data.timePlayedJob*10/(60*60))/10}} heures</span>
      <br /><span ng-show="data.group_id > 0">Groupe: <a href="#/group/{{(data.group_id - (data.group_id % 10))+1}}">{{data.group_name}}</a></span>
    </div>
    <br /><br />
    <div draw-line="right,65,125" class="box">
      Entraînement au couteau: {{data.train_knife}}%
      <br />Entraînement aux armes: {{Math.round(data.train_weapon*100/8)}}%
      <br />Entraînement à l'esquive: {{data.train_esquive}}%
    </div>
    <br /><br /><br /><br />
    <div draw-line="right,120,210" class="box">
      Argent: {{data.cash | number }}$
      <span ng-show="data.permi_lege+data.permi_lourd+data.permi_vente>1"><br />Permis: <span ng-show="data.permi_lege==1">léger</span> <span ng-show="data.permi_lourd==1">lourd</span> <span ng-show="data.permi_vente==1">vente</span></span>
      <span ng-show="data.have_account+data.pay_to_bank+data.have_card>1"><br />Possède: <span ng-show="data.have_account==1">Clé de coffre</span> <span ng-show="data.pay_to_bank==1">R.I.B.</span> <span ng-show="data.have_card==1">Carte bancaire</span></span>
    </div>
    <br />
    <div draw-line="right,125,280" class="box">
      <span>Temps de jeu ce mois: {{Math.round(data.timeplayed*10)/10}} heures</span>
      <br /><span>Dernière connexion: {{data.last_connected | date:'dd/MM/yy à HH:mm'}}</span>
    </div>
  </div>
  <div class="col-sm-4" style="margin-left:0px;">
      <img style="margin: 0 auto; position:relative; width:300px; height:410px; display:block; z-index:10" id="skin" src="/images/roleplay/skin/{{data.skin}}.bmp.png" />
  </div>
  <div class="col-sm-4">
    <div draw-line="left,150,100" class="box">
      Ratio: {{data.kill}} tués / {{data.death}} morts = {{Math.round(data.kill/data.death*100)/100}}<br />
      Niveau vitalité: {{data.vitality}}
    </div>
    <br /><br /><br />
    <button class="btn btn-danger" ng-show="data.job_id>0 && Params.sub==steamid" rest="delete@/user/job">Quitter mon job</button>
    <button class="btn btn-danger" ng-show="data.group_id>0 && Params.sub==steamid" rest="delete@/user/group">Quitter mon groupe</button>
    <button class="btn btn-success" ng-show="$parent.isAdmin" ng-click="steamid = Params.sub; toggleModal();">Envoyer argent</button>
    <a class="btn btn-warning" ng-show="$parent.isAdmin" href="#/tribunal/case/{{Params.sub}}">Page du Tribunal</a>
    <br /><br /><br /><br /><br />
    <a href="http://steamcommunity.com/profiles/{{data.steam64}}"><img src="http://steamsignature.com/status/french/{{data.steam64}}.png" /><img src="http://steamsignature.com/AddFriend.png" /></a>
    <div class="input-group col-sm-10">
        <span class="input-group-addon" required="">SteamID:</span>
        <input type="text" class="form-control" value="{{Params.sub}}">
    </div>

  </div>
</div>
<br clear="all" />
<div id="graph" draw-user-chart="https://www.ts-x.eu/api/user/{{Params.sub}}/incomes/24" style="height: 460px; margin: 0 auto; width:100%; display:block;"></div>

<div class="row">
  <div class="col-sm-4">
    <h3 class="row">Les quêtes accomplies par {{data.name}}</h3>
    <ul>
      <li ng-repeat="item in stats.quest">{{item.name}}
        <span class="pull-right">
          <span ng-show="item.completed == 1" class="text-success">Réussie</span>
          <span ng-hide="item.completed == 1" class="text-warning">Échec</span>
          {{item.time | date:'dd/MM à HH:mm' }}
        </span>
      </li>
    </ul>
  </div>
  <div class="col-sm-4">
    <h3 class="row">Stastistiques</h3>
    <ul>
      <li ng-repeat="item in stats.stat">{{item.name }}<span class="pull-right">{{item.data }}</span></li>
    </ul>
  </div>
  <div class="col-sm-4">
    <h3 class="row">Personnalité</h3>
    <div id="polar" draw-radar-chart="https://www.ts-x.eu/api/user/{{Params.sub}}/personality" style="height: 100%; margin: 0 auto; width:100%; display:block;"></div>
  </div>
</div>
<div class="row text-center" ng-show="data.job_id+data.group_id > 0 && $parent.steamid == Params.sub">
  <h2>Votre signature</h2>
  <img ng-show="data.job_id > 0"src="https://www.ts-x.eu/do/signature/job/{{Params.sub}}.jpg" />
  <img ng-show="data.group_id > 0" src="https://www.ts-x.eu/do/signature/group/{{Params.sub}}.jpg" />
</div>
<div modal-show="showDialog" class="modal fade">
  <div class="modal-dialog" ng-controller="rpSteamIDLookup">
    <form>
      <div class="modal-content">
        <div class="modal-header">
          <button type="button" class="close" data-dismiss="modal">&times;</button>
          <h4 class="modal-title">Envoyer de l'argent à un joueur</h4>
        </div>
        <div class="modal-body">
          <div class="input-group">
            <span class="input-group-addon" required>SteamID:</span>
            <input type="text" class="form-control" ng-model="steamid" />
            <span class="input-group-addon">{{pData.name}}</span>
          </div>
          <div class="input-group">
            <span class="input-group-addon">Montant:</span>
            <input type="number" class="form-control" ng-init="amount=0" ng-model="amount" value="0" min="0" max="{{data.cash}}" />
          </div>
        </div>
        <div class="modal-footer">
          <button class="btn btn-warning" data-dismiss="modal">Annuler</button>
          <input class="btn" type="submit" ng-class="(valid && amount > 0) ? 'btn-success' : 'disabled btn-warning'" value="Envoyer" rest="put@/user/{{steamid}}/sendMoney/{{amount}}" ng-click="toggleModal();" />
        </div>
      </div>
    </form>
  </div>
</div>
