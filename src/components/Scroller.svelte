<script>

</script>

<style lang="scss">
  scroller-background {
    display: block;
    width: 100%;
    height: 100%;
    will-change: transform;
    position: sticky;
    top: 0px;
    display: flex;
    flex-direction: column;
    justify-content: center;
    /* -webkit-transform: translate3d(0, 0, 0); */
  }

  scroller-foreground {
    display: block;
    position: relative;
    margin-top: -30vh;
    pointer-events: none;
  }
</style>

<div>
  <scroller-background>
    <slot name="background" />
  </scroller-background>

  <scroller-foreground>
    <slot name="foreground" />
  </scroller-foreground>
</div>
