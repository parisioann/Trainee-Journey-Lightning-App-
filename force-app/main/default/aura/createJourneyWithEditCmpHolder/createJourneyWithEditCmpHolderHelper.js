({
    onPageReferenceHelper : function(component) {
        var myPageRef = component.get("v.pageReference");
        var id = myPageRef.state.c__journey;
        component.set("v.id", id);   
    },
})
