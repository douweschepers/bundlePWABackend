var version = 'v2.1';

self.addEventListener('install', function(evt) {
	  console.log('The service worker is being installed.');
	  evt.waitUntil(precache());
});

self.addEventListener('fetch', function(evt) {
  console.log('The service worker is serving the asset.');
  evt.respondWith(fromNetwork(evt.request, 10000).catch(function () {
	    return fromCache(evt.request);
	  }));
	});

function precache() {
	  return caches.open(version).then(function (cache) {
	    return cache.addAll([
        	'index.jsp',
        	'login.jsp',
        	'account.jsp',
        	'loans.jsp',
        	'accounts.jsp',
        	'new_contract.jsp',
        	'new_group.jsp',
        	'group.jsp',
        	'groups.jsp',
        	'transactions.jsp',
        	'new_transaction.jsp',
        	'loan.jsp',
        	'edit_account.jsp',
        	'edit_loan.jsp',
        	'edit_contract.jsp',
        	'dashboard.jsp',
        	'group.jsp'
	    ]);
	  });
	}

function fromNetwork(request, timeout) {
	  return new Promise(function (fulfill, reject) {
		  
		  var timeoutId = setTimeout(reject, timeout);
		  fetch(request).then(function (response) {
		      clearTimeout(timeoutId);
		      fulfill(response);
		  }, reject);
	  });
	}

function fromCache(request) {
	  return caches.open(version).then(function (cache) {
	    return cache.match(request).then(function (matching) {
	      return matching || Promise.reject('no-match');
	    });
	  });
	}