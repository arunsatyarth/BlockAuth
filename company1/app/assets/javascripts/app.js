App = {
  web3Provider: null,
  contracts: {},
  account: '0x0',
  hasVoted: false,

  init: function() {
    return App.initWeb3();
  },

  initWeb3: function() {
    // TODO: refactor conditional
    if (typeof web3 !== 'undefined') {
      // If a web3 instance is already provided by Meta Mask.
      App.web3Provider = web3.currentProvider;
      web3 = new Web3(web3.currentProvider);
    } else {
      // Specify default instance if no web3 instance provided
      App.web3Provider = new Web3.providers.HttpProvider('http://localhost:7545');
      web3 = new Web3(App.web3Provider);
    }
      web3.eth.getCoinbase(function(err, account) {
      if (err === null) {
        App.account = account;
        $("#myAccount").html("Your Account: " + account);
      }
    });
    return App.initContract();
  },

  initContract: function() {
    $.getJSON("Registration.json", function(reg) {
      // Instantiate a new truffle contract from the artifact
      App.contracts.Registration = TruffleContract(reg);
      // Connect provider to interact with contract
      App.contracts.Registration.setProvider(App.web3Provider);

      //App.listenForEvents();

    });    
    $.getJSON("MS_Login.json", function(reg) {
      // Instantiate a new truffle contract from the artifact
      App.contracts.MS_Login = TruffleContract(reg);
      // Connect provider to interact with contract
      App.contracts.MS_Login.setProvider(App.web3Provider);

      //App.listenForEvents();

      return App.render();
    });
  },

  // Listen for events emitted from the contract
  /*
  listenForEvents: function() {
    App.contracts.Election.deployed().then(function(instance) {
      // Restart Chrome if you are unable to receive this event
      // This is a known issue with Metamask
      // https://github.com/MetaMask/metamask-extension/issues/2393
      instance.votedEvent({}, {
        fromBlock: 0,
        toBlock: 'latest'
      }).watch(function(error, event) {
        console.log("event triggered", event)
        // Reload when a new vote is recorded
        App.render();
      });
    });
  },
  */

  render: function() {
    var regInstance;
    var loader = $("#loader");
    var content = $("#content");
    var create_account_div = $("#create_account_div");
    var account_details_div = $("#account_details_div");

    loader.show();
    content.hide();


    // Load contract data
    App.contracts.Registration.deployed().then(function(instance) {
      regInstance = instance;
      let data=regInstance.users(App.account);
      return data;
    }).then(function(data) {
        loader.hide();
        content.show();
        if(data[0]=="")
        {
            create_account_div.show();
            account_details_div.hide();
            
        }
        else
        {//account is already created
            create_account_div.hide();
            account_details_div.show();
            $("#username").html(data[0]);
            $("#Name").html(data[1]);
            $("#picture").html(data[2]);

        }
    }).catch(function(error) {
      console.warn(error);
    });
  },

  createAccount: function() {
    var username = $('#form_username').val();
    var name = $('#form_name').val();
    var picture = $('#form_picture').val();
    if( username=="" || name=="" )
      return false;
    App.contracts.Registration.deployed().then(function(instance) {
      return instance.add_data(username,name,picture, { from: App.account });
    }).then(function(result) {
      // Wait for votes to update
      $("#content").hide();
      $("#loader").show();
    }).catch(function(err) {
      console.error(err);
    });
  },
  login: function() {
    if( global_uuid==null )
      return false;
    App.contracts.MS_Login.deployed().then(function(instance) {
      return instance.login(global_uuid, { from: App.account });
    }).then(function(result) {
          $.ajax({
             url: '/login', //your server side script
             data: { uuid: global_uuid }, //our data
              dataType:"script",
             type: 'POST'
         });
    }).catch(function(err) {
      console.error(err);
    });
  }
};

$(function() {
  $(window).load(function() {
    App.init();
  });
});
