<script async src="https://dn-lbstatics.qbox.me/busuanzi/2.3/busuanzi.pure.mini.js"></script>
<div class="copyright" >
  {% set current = date(Date.now(), "YYYY") %}
  &copy; {% if theme.since and theme.since != current %} {{ theme.since }} - {% endif %}
  <span itemprop="copyrightYear">{{ current }}</span>
  <span class="with-love">
    <i class="fa fa-{{ theme.authoricon }}"></i>
  </span>
  <span class="author" itemprop="copyrightHolder" style="font-weight: bold">{{ config.author }}</span>
  <div class="theme-info">
  <div class="powered-by"></div>
  </div>
  
  <!--<div class="powered-by">
    <span class="with-love"><i class="fa fa-eye"></i></span>
    <span id="busuanzi_value_site_pv"></span>
  </div>-->
  <div class="powered-by">
    Visitor count <span id="busuanzi_value_site_uv"></span>
  </div>
  <div class="theme-info">
    <span class="post-count">Word count {{ totalcount(site) }}</span>
  </div>
</div>