var version = 'v1';

self.addEventListener("install", function(event) {
	  console.log('WORKER: install event in progress.');
	  event.waitUntil(
	    caches
	      .open(version + 'fundamentals')
	      .then(function(cache) {
	        return cache.addAll([
	        	'index.jsp',
	        	'login.jsp',
	        	'account.jsp',
	        	'contract.jsp',
	        	'contracts.jsp',
	        	'allaccounts.jsp',
	        	'new_contract.jsp',
	        	'new_group.jsp',
	        	'group.jsp',
	        	'groups.jsp',
	        	'loan.jsp',
	        	'edit_account.jsp',
	        	'edit_loan.jsp',

	        	'edit_contract.jsp',
	        	'dashboard.jsp',
	        	'group.jsp'

	        ]);
	      })
	      .then(function() {
	        console.log('WORKER: install completed');
	      })
	  );
	});

self.addEventListener("fetch", function(event) {
	  console.log('WORKER: fetch event in progress.');

//	   We should only cache GET requests, and deal with the rest of method in the
//	     client-side, by handling failed POST,PUT,PATCH,etc. requests.

	  if (event.request.method !== 'GET') {
//	     If we don't block the event as shown below, then the request will go to
//	       the network as usual.

	    console.log('WORKER: fetch event ignored.', event.request.method, event.request.url);
	    return;
	  }
//	   Similar to event.waitUntil in that it blocks the fetch event on a promise.
//	     Fulfillment result will be used as the response, and rejection will end in a
//	     HTTP response indicating failure.

	  event.respondWith(
	    caches
//	       This method returns a promise that resolves to a cache entry matching
//	         the request. Once the promise is settled, we can then provide a response
//	         to the fetch request.

	      .match(event.request)
	      .then(function(cached) {
	        var networked = fetch(event.request)
	          .then(fetchedFromNetwork, unableToResolve)
	          .catch(unableToResolve);
	        console.log('WORKER: fetch event', cached ? '(cached)' : '(network)', event.request.url);
	        return cached || networked;

	        function fetchedFromNetwork(response) {
	          var cacheCopy = response.clone();

	          console.log('WORKER: fetch response from network.', event.request.url);

	          caches
	            .open(version + 'pages')
	            .then(function add(cache) {

	              cache.put(event.request, cacheCopy);
	            })
	            .then(function() {
	              console.log('WORKER: fetch response stored in cache.', event.request.url);
	            });
	          return response;
	        }

	        function unableToResolve () {

	          console.log('WORKER: fetch request failed in both cache and network.');

	          return new Response('<h1>Service Unavailable</h1>', {
	            status: 503,
	            statusText: 'Service Unavailable',
	            headers: new Headers({
	              'Content-Type': 'text/html'
	            })
	          });
	        }
	      })
	  );
	});

self.addEventListener("activate", function(event) {
	  console.log('WORKER: activate event in progress.');

	  event.waitUntil(
	    caches
	      .keys()
	      .then(function (keys) {
	        return Promise.all(
	          keys
	            .filter(function (key) {
	              return !key.startsWith(version);
	            })
	            .map(function (key) {
	              return caches.delete(key);
	            })
	        );
	      })
	      .then(function() {
	        console.log('WORKER: activate completed.');
	      })
	  );
	});
