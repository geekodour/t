<script>
	import '../app.css';
</script>

<!-- <script>
	 import '../app.css';
	 import Navbar from '$lib/components/sections/navbar/navbar.svelte';
     </script> -->

<div class="flex flex-col justify-between min-h-dvh">
	<div class="container h-5/6 grow overflow-hidden px-0 py-2">
	    <!-- <div class="pb-2"><Navbar /></div> -->
		<slot> </slot>
	</div>
	<div>
		<div class="flex justify-center p-4 bg-stone-300">
			footer! | 2024
		</div>
	</div>
</div>
