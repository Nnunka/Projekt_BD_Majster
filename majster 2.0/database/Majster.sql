PGDMP                          {           Majster    15.2    15.2 #    4           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            5           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            6           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            7           1262    17586    Majster    DATABASE     |   CREATE DATABASE "Majster" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Polish_Poland.1250';
    DROP DATABASE "Majster";
                Majster    false            �            1259    17587    users    TABLE     �  CREATE TABLE public.users (
    user_id bigint NOT NULL,
    user_name character varying(100) NOT NULL,
    user_surname character varying(100) NOT NULL,
    user_email character varying(100) NOT NULL,
    user_login character varying(100) NOT NULL,
    user_password character varying(100) NOT NULL,
    user_role character varying(100) DEFAULT USER NOT NULL,
    user_exist boolean DEFAULT true NOT NULL
);
    DROP TABLE public.users;
       public         heap    postgres    false            �            1259    17594    users_user_id_seq    SEQUENCE     z   CREATE SEQUENCE public.users_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.users_user_id_seq;
       public          postgres    false    214            8           0    0    users_user_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.users_user_id_seq OWNED BY public.users.user_id;
          public          postgres    false    215            �            1259    17595    alerts    TABLE       CREATE TABLE public.alerts (
    alert_id bigint DEFAULT nextval('public.users_user_id_seq'::regclass) NOT NULL,
    alert_title character varying(100) NOT NULL,
    alert_who_add_id bigint NOT NULL,
    alert_details character varying(10000) NOT NULL,
    alert_add_date timestamp with time zone NOT NULL,
    alert_exist boolean DEFAULT true NOT NULL,
    alert_machine_id bigint DEFAULT 0,
    alert_status character varying DEFAULT 'Brak'::character varying NOT NULL,
    alert_repairer_id bigint DEFAULT 0
);
    DROP TABLE public.alerts;
       public         heap    postgres    false    215            �            1259    17605    machines    TABLE     
  CREATE TABLE public.machines (
    machine_id bigint NOT NULL,
    machine_name character varying(100) NOT NULL,
    machine_type character varying(100) NOT NULL,
    machine_status character varying(100) NOT NULL,
    machine_exist boolean DEFAULT true NOT NULL
);
    DROP TABLE public.machines;
       public         heap    postgres    false            �            1259    17609    machines_machine_id_seq    SEQUENCE     �   CREATE SEQUENCE public.machines_machine_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.machines_machine_id_seq;
       public          postgres    false    217            9           0    0    machines_machine_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.machines_machine_id_seq OWNED BY public.machines.machine_id;
          public          postgres    false    218            �            1259    17610    realize_tasks    TABLE     �   CREATE TABLE public.realize_tasks (
    realize_id bigint DEFAULT nextval('public.users_user_id_seq'::regclass) NOT NULL,
    realize_user_id bigint NOT NULL,
    realize_machine_id bigint NOT NULL,
    realize_task_id bigint NOT NULL
);
 !   DROP TABLE public.realize_tasks;
       public         heap    postgres    false    215            �            1259    17614    services    TABLE     #  CREATE TABLE public.services (
    service_id bigint DEFAULT nextval('public.machines_machine_id_seq'::regclass) NOT NULL,
    service_title character varying(100) NOT NULL,
    service_machine_id bigint NOT NULL,
    service_details character varying(10000) NOT NULL,
    service_start_date timestamp with time zone NOT NULL,
    service_end_date timestamp with time zone,
    service_exist boolean DEFAULT true NOT NULL,
    service_status character varying(20) DEFAULT 'Nie zaczęte'::character varying,
    service_user_id bigint DEFAULT 0
);
    DROP TABLE public.services;
       public         heap    postgres    false    218            �            1259    17623    tasks    TABLE     �  CREATE TABLE public.tasks (
    task_id bigint DEFAULT nextval('public.machines_machine_id_seq'::regclass) NOT NULL,
    task_title character varying(100) NOT NULL,
    task_details character varying(10000) NOT NULL,
    task_add_date timestamp with time zone NOT NULL,
    task_start_date timestamp with time zone,
    task_end_date timestamp with time zone,
    task_exist boolean DEFAULT true NOT NULL,
    task_start_date_by_user timestamp with time zone
);
    DROP TABLE public.tasks;
       public         heap    postgres    false    218            �           2604    17630    machines machine_id    DEFAULT     z   ALTER TABLE ONLY public.machines ALTER COLUMN machine_id SET DEFAULT nextval('public.machines_machine_id_seq'::regclass);
 B   ALTER TABLE public.machines ALTER COLUMN machine_id DROP DEFAULT;
       public          postgres    false    218    217            z           2604    17631    users user_id    DEFAULT     n   ALTER TABLE ONLY public.users ALTER COLUMN user_id SET DEFAULT nextval('public.users_user_id_seq'::regclass);
 <   ALTER TABLE public.users ALTER COLUMN user_id DROP DEFAULT;
       public          postgres    false    215    214            ,          0    17595    alerts 
   TABLE DATA           �   COPY public.alerts (alert_id, alert_title, alert_who_add_id, alert_details, alert_add_date, alert_exist, alert_machine_id, alert_status, alert_repairer_id) FROM stdin;
    public          postgres    false    216   s.       -          0    17605    machines 
   TABLE DATA           i   COPY public.machines (machine_id, machine_name, machine_type, machine_status, machine_exist) FROM stdin;
    public          postgres    false    217   �0       /          0    17610    realize_tasks 
   TABLE DATA           i   COPY public.realize_tasks (realize_id, realize_user_id, realize_machine_id, realize_task_id) FROM stdin;
    public          postgres    false    219   k1       0          0    17614    services 
   TABLE DATA           �   COPY public.services (service_id, service_title, service_machine_id, service_details, service_start_date, service_end_date, service_exist, service_status, service_user_id) FROM stdin;
    public          postgres    false    220   �1       1          0    17623    tasks 
   TABLE DATA           �   COPY public.tasks (task_id, task_title, task_details, task_add_date, task_start_date, task_end_date, task_exist, task_start_date_by_user) FROM stdin;
    public          postgres    false    221   �3       *          0    17587    users 
   TABLE DATA              COPY public.users (user_id, user_name, user_surname, user_email, user_login, user_password, user_role, user_exist) FROM stdin;
    public          postgres    false    214   �5       :           0    0    machines_machine_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.machines_machine_id_seq', 99, true);
          public          postgres    false    218            ;           0    0    users_user_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.users_user_id_seq', 101, true);
          public          postgres    false    215            �           2606    17633    alerts alerts_pkay 
   CONSTRAINT     V   ALTER TABLE ONLY public.alerts
    ADD CONSTRAINT alerts_pkay PRIMARY KEY (alert_id);
 <   ALTER TABLE ONLY public.alerts DROP CONSTRAINT alerts_pkay;
       public            postgres    false    216            �           2606    17635    machines machines_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.machines
    ADD CONSTRAINT machines_pkey PRIMARY KEY (machine_id);
 @   ALTER TABLE ONLY public.machines DROP CONSTRAINT machines_pkey;
       public            postgres    false    217            �           2606    17637    realize_tasks mut_pkay 
   CONSTRAINT     \   ALTER TABLE ONLY public.realize_tasks
    ADD CONSTRAINT mut_pkay PRIMARY KEY (realize_id);
 @   ALTER TABLE ONLY public.realize_tasks DROP CONSTRAINT mut_pkay;
       public            postgres    false    219            �           2606    17639    services serwic_pkay 
   CONSTRAINT     Z   ALTER TABLE ONLY public.services
    ADD CONSTRAINT serwic_pkay PRIMARY KEY (service_id);
 >   ALTER TABLE ONLY public.services DROP CONSTRAINT serwic_pkay;
       public            postgres    false    220            �           2606    17641    tasks tasks_pkay 
   CONSTRAINT     S   ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_pkay PRIMARY KEY (task_id);
 :   ALTER TABLE ONLY public.tasks DROP CONSTRAINT tasks_pkay;
       public            postgres    false    221            �           2606    17643    users users_pkey 
   CONSTRAINT     S   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);
 :   ALTER TABLE ONLY public.users DROP CONSTRAINT users_pkey;
       public            postgres    false    214            �           2606    17644    services machine_fkay    FK CONSTRAINT     �   ALTER TABLE ONLY public.services
    ADD CONSTRAINT machine_fkay FOREIGN KEY (service_machine_id) REFERENCES public.machines(machine_id) NOT VALID;
 ?   ALTER TABLE ONLY public.services DROP CONSTRAINT machine_fkay;
       public          postgres    false    217    220    3216            �           2606    17649    realize_tasks machine_fkay    FK CONSTRAINT     �   ALTER TABLE ONLY public.realize_tasks
    ADD CONSTRAINT machine_fkay FOREIGN KEY (realize_machine_id) REFERENCES public.machines(machine_id) NOT VALID;
 D   ALTER TABLE ONLY public.realize_tasks DROP CONSTRAINT machine_fkay;
       public          postgres    false    3216    217    219            �           2606    17654    realize_tasks taask_fkay    FK CONSTRAINT     �   ALTER TABLE ONLY public.realize_tasks
    ADD CONSTRAINT taask_fkay FOREIGN KEY (realize_task_id) REFERENCES public.tasks(task_id) NOT VALID;
 B   ALTER TABLE ONLY public.realize_tasks DROP CONSTRAINT taask_fkay;
       public          postgres    false    221    3222    219            �           2606    17659    alerts user_fkay    FK CONSTRAINT     �   ALTER TABLE ONLY public.alerts
    ADD CONSTRAINT user_fkay FOREIGN KEY (alert_who_add_id) REFERENCES public.users(user_id) NOT VALID;
 :   ALTER TABLE ONLY public.alerts DROP CONSTRAINT user_fkay;
       public          postgres    false    3212    214    216            �           2606    17664    realize_tasks user_fkay    FK CONSTRAINT     �   ALTER TABLE ONLY public.realize_tasks
    ADD CONSTRAINT user_fkay FOREIGN KEY (realize_user_id) REFERENCES public.users(user_id) NOT VALID;
 A   ALTER TABLE ONLY public.realize_tasks DROP CONSTRAINT user_fkay;
       public          postgres    false    214    3212    219            ,   v  x�}T���0��P����K�]���L�4�X�m<��1ef�y��w�?��7+�������F�l[g���,N�x��[�ǵS��(G��S�DWڠ��V��uH���Ct1��l*_�~s�Gx����S�3��Di�`���n�?7%��/�A1��JE�Y�4է�_��?D��y���I�"���o�Z|��eU�ep�"�'���5ڕ�Y� ����Sح�0��q�/>����?�l�:�s�>G�K��9��<~܇]�X� �M�_e(�GC�Ҥ#�0�1��>P�Yޮ�R�|3��T��0�X���G��pLi�B.+P6V�{��8jA�_֓  ���h�� 5��Z���v�),�1=�)J�d���N�l�]u$��!,C߮Ey��4:lo�z9��:D*9�33*
?�xO�s'���dX�1�UiuI+$Pz��K����ْ$�]�ue�E!1��n��Q9n
�h� �w�[��I�E���W�D�CڤE�Y���o������������7�~�m�	/^��#ae:��/��	C,�}��Sh����}�5�)u�Hcͤ9�ͭ؄���_7-[+{�;:y�.�]���w�Z���}��      -   b   x�32���LW�MLW�L�,.H,O,�N�.(J,�K�,�24��H,��K/�ϋ7q7�,�,H�AWd2���(5�He��8���M8K��4��qqq l+'�      /      x������ � �      0   �  x���݊�0����}����9
��X�R���bv/�n}���ԉ�P� $�Ɵ�Μ���R�r�x���,P����쁂D��M�}��	!i]oO������ϣp�6���J�^��--�& Oa:X`}��A^��*wE�D�4&��!s�A}QB�|�	�;^��)�X%)����դ�uܒ(k/�\�{C֓��GR�]YG�^���C�_����vp�jQAYoz�_9����+��8��2ʗ�Y>����,���*��m����+���Zd��"c�R�R�¡Yr�lR�c��O�c�?�kɞƅ'�&��Y/W�F٢�<�6K�������N���K�>^!�vw ~��I.Q|Џ0hW��E�w�uҵ�0z`f��ncE��-����h�8��)�u'���=�����!��<����q}��[ӼĻZ�\��|_�֏������q�H׬���{H�*�y=��t����X�}l�3�r��и���W��!us�OUD�!��a~�i8      1     x��T���0���H�AR�^�}�5l�������K"k�X����!��B�4�aA�ٝQΜO��"x��[(BH��;R�[$@�_�I�ۼ���s��SA.��RS�xFR;!�j_H?-�~ F	�6-6�i[��˻t"u-��ۨD�-^n��S�8*�C٠�:`r���~Y�uަ鲩7:�$�w�D���\1��:�J�����:�E5�i'�.O~~��*U�1��r|,�k�J�i�.�u�����H�e���0����#�QՂ�C�=p���0���s�ܫ�����⹥wt"��b�|�޳��F4��S{N�S��rx�@ �ЁN��xP�]�c.JeϏrN�PbMN���ҴZU��-�U>ˡ��[4��4���l%����꫎� ��sڑ�I:P(.Cr��w0��=Q�O5��o��"��o�kC��w�J�>��Z�3N�P�֪�G2�i�U���^��ܘ��4�����{l��Zːs퉿0��7��Ls      *   �   x�u�M
�0�דÔ�?�At#�K7�F��im���x/�M�q�x3���e�G��A���SHh�X�M�(0�^��-�I��`�J�ǫonh"J��)��j���RB��O'o�� �-�Z�Uǭ+.�J����c����.H�&FZޠh��9u�g�N�em�S����O��y�j�������輗O��}{��x���C�� ��     