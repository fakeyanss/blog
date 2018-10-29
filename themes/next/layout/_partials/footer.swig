<script async src="https://dn-lbstatics.qbox.me/busuanzi/2.3/busuanzi.pure.mini.js"></script>
<div class="copyright" style="text-align:center">
  {% set current = date(Date.now(), "YYYY") %}
  &copy; {% if theme.since and theme.since != current %} {{ theme.since }} - {% endif %}
  <span itemprop="copyrightYear">{{ current }}</span>
  <span class="with-love">
    <i class="fa fa-{{ theme.authoricon }}"></i>
  </span>
  <span class="author" itemprop="copyrightHolder" style="font-weight: bold;padding-right: 5px">{{ config.author }}.</span>
  <span style="padding-right: 5px">All Rights Reserved</span>
  <span><a href="http://www.beian.gov.cn/portal/index" target="_blank" style="border-bottom: none">鄂ICP备18021807号</a></span>
  
  <div classs="theme-info"></div>
  <!--<div class="powered-by">
    <span class="with-love"><i class="fa fa-eye"></i></span>
    <span id="busuanzi_value_site_pv"></span>
  </div>-->
  <!--<div class="powered-by">
    Visitor count <span id="busuanzi_value_site_uv"></span>
  </div>-->
  <div class="theme-info">
    <span class="post-count">Word count {{ totalcount(site) }}</span>
  </div>
</div>