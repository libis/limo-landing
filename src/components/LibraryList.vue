<template>
  <section class="section" style="background:#4f6e86;padding-bottom:1rem;">
    <div class="container" >
      <img alt="Vue logo" src="./../assets/limo.png">     
    </div>
    
  </section>
  <section class="section" style="background:#f5f5f5;padding-top:1rem;">
    <div class="container">
      
        <div class="level">
        <div class="level-left">        
          <div class="level-item">
            <div class="field has-addons"> 
              <p class="control has-icons-right" style="margin-right:1rem;">
                <input class="input" v-model="searchTerm" type="text" style="border-radius:0;">
                <span class="icon is-small is-right">
                  <i class="fas fa-search"></i>
                </span>
              </p>

              <button class="button" @click="sort('name')" v-bind:class="[sort_by === 'name' ? sort_dir : '']" style="border-radius:0;">
                <span class="icon is-small is-left">
                  <i v-if="sort_dir == 'asc'" class="fas fa-sort-alpha-down" aria-label="Sort ascending"></i>
                  <i v-if="sort_dir == 'desc'" class="fas fa-sort-alpha-down-alt" aria-label="Sort descending"></i>
                </span>
              </button>
            </div>  
          </div>          
          
        </div>
        <div class="level-right">
          <div class="level-item">
            <div class="buttons">
              <a @click="settag('kuleuven')" class="button is-primary" v-bind:class="{ 'is-outlined':  this.tag  != 'kuleuven'}">KU Leuven Associatie</a>
              <a @click="settag('libisnet')" class="button is-primary" v-bind:class="{ 'is-outlined':  this.tag  != 'libisnet' }">Andere</a>
              <a @click="settag('All')" class="button is-primary" v-bind:class="{ 'is-outlined':  this.tag  != '' }">Alles</a>
            </div>
          </div>
        </div>
      </div>  
      <div v-if="fave != ''" class="level" style="padding-top:0rem;">
        <div class="level-left">     
          <div class="level-item">
            <div class="block">              
              <a class="has-text-weight-semibold button is-warning" href="">       
                <span class="icon" ><i class="fas fa-star"></i></span>         
                <span><span style="font-weight:300;margin-right:0.5rem;">Laatst bezocht: </span>
                {{ fave.name }}</span>
                
              </a>
            </div>
          </div>
        </div>
      </div>  
      <div class="libraries columns is-multiline">
        <div v-for="institution in filterByTerm" :key="institution.id" class="column is-3">
          <div class="box">
           <img v-if="institution.name == 'European Central Bank'" src="https://ecb-europea-psb.primo.exlibrisgroup.com/discovery/custom/thumbnails/thumbnail_49ECB_INST-ECB.png">
           <img v-if="institution.name != 'European Central Bank'" style="height:50px;" :src="'https://'+institution.code+'.limo.libis.be/discovery/custom/'+institution.vidve.replace(':','-')+'/img/library-logo.png'">
          
           <div style="height:50px;" class="block">
              <h2 class="title is-6 my-3">
                <a v-if="!institution.fullurl" class="has-text-primary" @click="setLastVisited(institution)" :href="'https://'+institution.code+'.limo.libis.be/discovery/search?vid='+institution.vidve">{{ institution.name }}</a>
                <a v-if="institution.fullurl" class="has-text-primary" @click="setLastVisited(institution)" :href="institution.fullurl">{{ institution.name }}</a>
               
              </h2>
            </div>
          </div>
        </div>  
      </div>
    </div>
  </section>
</template>

<script>
import {ref} from 'vue';
import _ from 'lodash';

export default {
  name: 'LibraryList',

  data: () => ({
    sort_by: 'title',
    sort_dir: 'asc',
    searchTerm: '',
    fave: '',
    tag: ''
  }),

  methods: {
    sort(s){
      if(s === this.sort_by) {
          this.sort_dir = this.sort_dir === 'asc' ? 'desc' : 'asc';
      }
      this.sort_by = s;
    },

    settag(t){
      this.tag = t;
      if(t == 'All'){
        this.tag = '';
      }
    },

    setLastVisited(institution){
      localStorage.fave = JSON.stringify(institution);
      this.fave = institution;
    }
  },

  computed: {
    sortedInstitutions: function(){
      return _.orderBy(this.institutions,this.sort_by,this.sort_dir)
    },

    filterByTerm() {
      return this.sortedInstitutions.filter(i => {
        //filter with lower case
        return (i.name.toLowerCase().includes(this.searchTerm.toLowerCase()) && i.display == true && (i.group == this.tag || this.tag == ''));
      });
    },

    filterByTag() {
      if(this.tag){
        return this.sortedInstitutions.filter(i => {
          //filter with lower case
          return (i.group == this.tag && i.display == true);
        });
      }
      return this.sortedInstitutions;  
    }

  },

  props: {
    msg: String
  },

  mounted() {
    if (localStorage.fave) {
      this.fave = JSON.parse(localStorage.fave);
    }
  },


  setup() {
    const institutions = ref([
            {group: 'libisnet', inst_group: '', sort: '', name: 'AB', code: 'AB', vid: 'AB', width: '60px', display: false, vidve:'32KUL_KHL:UCLL',fullurl:''},
            {group: 'libisnet', inst_group: '', sort: '', name: 'ACV', code: 'ACV', vid: 'ACV', width: '60px', display: true, vidve:'32KUL_ACV:ACV',fullurl:''},
            {group: 'libisnet', inst_group: '', sort: '', name: 'Federale Parlement fédéral', code: 'BPB', vid: 'BPB', width: '180px', display: true, vidve:'32KUL_BPB:BPB',fullurl:''},
            {group: 'libisnet', inst_group: '', sort: '', name: 'FARO', code: 'FARO', vid: 'FARO', width: '60px', display: true, vidve:'32KUL_VCV:FARO',fullurl:''},
            {group: 'libisnet', inst_group: '', sort: '', name: 'Federale Overheidsdienst Financiën', code: 'fin', vid: 'FODFIN', width:'120px', display: true, vidve:'32KUL_FIN:FODFIN',fullurl:''},
            {group: 'libisnet', inst_group: '', sort: '', name: 'IMEC', code: 'IMEC', vid: 'IMEC', width: '60px', display: true, vidve:'32KUL_IMEC:IMEC',fullurl:''},
            {group: 'libisnet', inst_group: '', sort: '', name: 'KBC', code: 'KBC', vid: 'KBC', width: '60px', display: true, vidve:'32KUL_KBC:KBC',fullurl:''},
            {group: 'libisnet', inst_group: '', sort: '', name: 'Koninklijke Musea voor Kunst en Geschiedenis', code: 'KMKG', vid: 'KMKG', width: '90px', display: true, vidve:'32KUL_KMMR:KMKG',fullurl:''},
            {group: 'kuleuven', inst_group: 'kulloc,KULeuven_regio)', sort: 0, name: 'KU Leuven, Campus Leuven, Kortrijk, Antwerpen, Brugge en Sint-Lucas Brussel en TDC Gent', code: 'KULeuven', vid: 'KULeuven', width: '80px', display: true, vidve:'32KUL_KUL:KULeuven',fullurl:''},
            {group: 'kuleuven', inst_group: 'kulloc,KULeuven_regio', sort: 2, name: 'KU Leuven, Alle campussen', code: 'kuleuven', vid: 'KULeuven', width: '80px', display: true, vidve:'32KUL_KUL:REGIONAL',fullurl:''},
            {group: 'kuleuven', inst_group: '', sort: 7, name: 'LUCA School of Arts', code: 'LUCA', vid: 'LUCA', width: '80px', display: true, vidve:'32KUL_LUCAWENK:LUCA',fullurl:''},
            {group: 'kuleuven', inst_group: 'hub_kaho', sort: 8, name: 'Odisee', code: 'ODISEE', vid: 'ODISEE', width: '80px', display: true, vidve:'32KUL_HUB:ODISEE',fullurl:''},
            {group: 'kuleuven', inst_group: 'tmore', sort: 10, name: 'Thomas More Geel, Lier, Turnhout, Vorselaar', code: 'kempen.thomasmore', vid: 'TMOREK', width: '80px', display: true, vidve:'32KUL_KHK:TMOREK',fullurl:''},
            {group: 'kuleuven', inst_group: 'tmore', sort: 11, name: 'Thomas More Antwerpen, Mechelen, Sint-Katelijne-waver', code: 'mechelen-antwerpen.thomasmore', vid: 'TMOREM', width: '80px', display: true, vidve:'32KUL_KHM:TMOREMA',fullurl:''},
            {group: 'kuleuven', inst_group: 'ucll', sort: 12, name: 'UCLL', code: 'UCLL', vid: 'UCLL', width: '80px', display: true, vidve:'32KUL_KHL:UCLL',fullurl:''},
            {group: 'kuleuven', inst_group: 'vives', sort: 14, name: 'VIVES', code: 'VIVES', vid: 'VIVES', width: '80px', display: true, vidve:'32KUL_KATHO:VIVES',fullurl:''},
            {group: 'libisnet', inst_group: '', sort: '', name: 'Nationale Bank van België', code: 'NBB', vid: 'NBB', width: '120px', display: true, vidve:'32KUL_NBB:NBB',fullurl:''},
            {group: 'libisnet', inst_group: '', sort: '', name: 'SPF BOSA/FOD BOSA', code: 'bosa', vid: 'OFO', width: '60px', display: true, vidve:'32KUL_TIFA:BOSA',fullurl:''},
            {group: 'libisnet', inst_group: '', sort: '', name: 'Koninklijk Belgisch Instituut voor Natuurwetenschappen', code: 'RBINS', vid: 'RBINS', width: '120px', display: true, vidve:'32KUL_RBINS:RBINS',fullurl:''},
            {group: 'libisnet', inst_group: '', sort: '', name: 'Koninklijk Museum voor Midden-Afrika', code: 'RMCA', vid: 'RMCA', width: '60px', display: true, vidve:'32KUL_RMCA:RMCA',fullurl:''},
            {group: 'libisnet', inst_group: '', sort: '', name: 'Vesalius Documentation and Information Center', code: 'VDIC', vid: 'VDIC', width: '100px', display: true, vidve:'32KUL_VES:VDIC',fullurl:''},
            {group: 'libisnet', inst_group: '', sort: '', name: 'Parlementair Informatiecentrum van het Vlaams Parlement', code: 'VLP', vid: 'VLP', width: '100px', display: true, vidve:'32KUL_VLP:VLP',fullurl:''},
            {group: 'libisnet', inst_group: 'reli', sort: '', name: 'Documentatie- en Onderzoekscentrum voor Religie, Cultuur en Samenleving', code: 'KADOC', vid: 'KADOC', width: '80px', display: true, vidve:'32KUL_KADOC:KADOC',fullurl:''},
            {group: 'libisnet', inst_group: 'reli', sort: '', name: 'Grootseminarie Gent', code: 'GSG', vid: 'GSG', width: '60px', display: true, vidve:'32KUL_GSG:GSG',fullurl:''},
            {group: 'libisnet', inst_group: 'reli', sort: '', name: 'Grootseminarie Brugge', code: 'GSB', vid: 'GSB', width: '30px', display: true, vidve:'32KUL_GSB:GSB',fullurl:''},
            {group: 'libisnet', inst_group: '', sort: '', name: 'European Central Bank', code: 'ECB', vid: 'ECB', width: '120px', display: true, vidve:'49ECB_INST:ECB',fullurl:'https://ecb-europea-psb.primo.exlibrisgroup.com/discovery/search?vid=49ECB_INST:ECB'},
            //{group: 'libisnet', inst_group: 'music', sort: '', name: 'Muziekcatalogus [LUCA]', code: 'LUCA_MUSIC', vid: 'LUCA_MUSIC', width: '200px', display: true},
            //{group: 'libisnet', inst_group: 'music', sort: '', name: 'Muziekcatalogus [KU Leuven]', code: 'KULEUVEN_MUSIC', vid: 'KULEUVEN_MUSIC', width: '200px', display: true},
            {group: 'libisnet', inst_group: 'bibl', sort: '', name: 'Lirias', code: 'kuleuven', vid: 'Lirias', width: '90px', display: true, vidve:'32KUL_KUL:Lirias',fullurl:''},
            {group: 'libisnet', inst_group: 'bibl', sort: '', name: 'DokS', code: 'kuleuven', vid: 'DOKS', width: '80px', display: true, vidve:'32KUL_LIBIS_NETWORK:DOKS',fullurl:''},
            {group: 'libisnet', inst_group: 'bibl', sort: '', name: 'Jesuit Armarium', code: 'kadoc', vid: 'JESUITS', width: '80px', display: true, vidve:'32KUL_KUL:JESUITS',fullurl:''},
            {group: 'libisnet', inst_group: '', sort: '', name: 'Documentatiecentrum Vlaams Brabant', code: 'docvlaamsbrabant', vid: 'docvlaamsbrabant', width: '80px', display: true, vidve:'32KUL_DOCVB:docvlaamsbrabant',fullurl:''},


        ]);

        return {
            institutions
        };
  }

}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
h3 {
  margin: 40px 0 0;
}
ul {
  list-style-type: none;
  padding: 0;
}
li {
  display: inline-block;
  margin: 0 10px;
}
a {
  color: #42b983;
}
</style>
