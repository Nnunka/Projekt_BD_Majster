PGDMP         8                {           Majster    15.3    15.3 3    Y           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            Z           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            [           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            \           1262    16700    Majster    DATABASE     |   CREATE DATABASE "Majster" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Polish_Poland.1250';
    DROP DATABASE "Majster";
                postgres    false            �            1255    16701    delete_alert()    FUNCTION     ~  CREATE FUNCTION public.delete_alert() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO alerts_archive (alert_title, alert_who_add_id, alert_details, alert_add_date, alert_machine_id, alert_repairer_id)
    SELECT OLD.alert_title, OLD.alert_who_add_id, OLD.alert_details, OLD.alert_add_date, OLD.alert_machine_id, OLD.alert_repairer_id;

    RETURN OLD;
END;
$$;
 %   DROP FUNCTION public.delete_alert();
       public          postgres    false            �            1255    16702    delete_service()    FUNCTION     �  CREATE FUNCTION public.delete_service() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO serwices_archive (service_title, service_machine_id, service_details, service_start_date, service_end_date, service_user_id)
    SELECT OLD.service_title, OLD.service_machine_id, OLD.service_details, OLD.service_start_date, OLD.service_end_date, OLD.service_user_id;

    RETURN OLD;
END;
$$;
 '   DROP FUNCTION public.delete_service();
       public          postgres    false            �            1255    16703    delete_task()    FUNCTION     z  CREATE FUNCTION public.delete_task() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO tasks_archive (task_title, task_details, task_add_date, task_start_date, task_end_date, task_start_date_by_user)
    SELECT OLD.task_title, OLD.task_details, OLD.task_add_date, OLD.task_start_date, OLD.task_end_date, OLD.task_start_date_by_user;

    RETURN OLD;
END;
$$;
 $   DROP FUNCTION public.delete_task();
       public          postgres    false            �            1259    16704    users    TABLE     �  CREATE TABLE public.users (
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
       public         heap    postgres    false            �            1259    16711    users_user_id_seq    SEQUENCE     z   CREATE SEQUENCE public.users_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.users_user_id_seq;
       public          postgres    false    214            ]           0    0    users_user_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.users_user_id_seq OWNED BY public.users.user_id;
          public          postgres    false    215            �            1259    16712    alerts    TABLE       CREATE TABLE public.alerts (
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
       public         heap    postgres    false    215            �            1259    16722    alerts_archive    TABLE     �  CREATE TABLE public.alerts_archive (
    alert_archive_id bigint DEFAULT nextval('public.users_user_id_seq'::regclass) NOT NULL,
    alert_title character varying(100) NOT NULL,
    alert_who_add_id bigint NOT NULL,
    alert_details character varying(10000) NOT NULL,
    alert_add_date timestamp with time zone NOT NULL,
    alert_machine_id bigint DEFAULT 0,
    alert_delete_date timestamp with time zone DEFAULT now() NOT NULL,
    alert_repairer_id bigint DEFAULT 0
);
 "   DROP TABLE public.alerts_archive;
       public         heap    postgres    false    215            �            1259    16731    machines    TABLE     
  CREATE TABLE public.machines (
    machine_id bigint NOT NULL,
    machine_name character varying(100) NOT NULL,
    machine_type character varying(100) NOT NULL,
    machine_status character varying(100) NOT NULL,
    machine_exist boolean DEFAULT true NOT NULL
);
    DROP TABLE public.machines;
       public         heap    postgres    false            �            1259    16735    machines_machine_id_seq    SEQUENCE     �   CREATE SEQUENCE public.machines_machine_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.machines_machine_id_seq;
       public          postgres    false    218            ^           0    0    machines_machine_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.machines_machine_id_seq OWNED BY public.machines.machine_id;
          public          postgres    false    219            �            1259    16736    realize_tasks    TABLE     �   CREATE TABLE public.realize_tasks (
    realize_id bigint DEFAULT nextval('public.users_user_id_seq'::regclass) NOT NULL,
    realize_user_id bigint NOT NULL,
    realize_machine_id bigint NOT NULL,
    realize_task_id bigint NOT NULL
);
 !   DROP TABLE public.realize_tasks;
       public         heap    postgres    false    215            �            1259    16740    services    TABLE     #  CREATE TABLE public.services (
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
       public         heap    postgres    false    219            �            1259    16749    serwices_archive    TABLE     �  CREATE TABLE public.serwices_archive (
    service_archive_id bigint DEFAULT nextval('public.machines_machine_id_seq'::regclass) NOT NULL,
    service_title character varying(100) NOT NULL,
    service_machine_id bigint NOT NULL,
    service_details character varying(10000) NOT NULL,
    service_start_date timestamp with time zone NOT NULL,
    service_end_date timestamp with time zone,
    service_delete_data timestamp with time zone DEFAULT now() NOT NULL,
    service_user_id bigint DEFAULT 0
);
 $   DROP TABLE public.serwices_archive;
       public         heap    postgres    false    219            �            1259    16757    tasks    TABLE     �  CREATE TABLE public.tasks (
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
       public         heap    postgres    false    219            �            1259    16764    tasks_archive    TABLE     �  CREATE TABLE public.tasks_archive (
    task_archive_id bigint DEFAULT nextval('public.machines_machine_id_seq'::regclass) NOT NULL,
    task_title character varying(100) NOT NULL,
    task_details character varying(10000) NOT NULL,
    task_add_date timestamp with time zone NOT NULL,
    task_start_date timestamp with time zone,
    task_end_date timestamp with time zone,
    task_start_date_by_user timestamp with time zone,
    task_delete_time timestamp with time zone DEFAULT now()
);
 !   DROP TABLE public.tasks_archive;
       public         heap    postgres    false    219            �           2604    16771    machines machine_id    DEFAULT     z   ALTER TABLE ONLY public.machines ALTER COLUMN machine_id SET DEFAULT nextval('public.machines_machine_id_seq'::regclass);
 B   ALTER TABLE public.machines ALTER COLUMN machine_id DROP DEFAULT;
       public          postgres    false    219    218            �           2604    16772    users user_id    DEFAULT     n   ALTER TABLE ONLY public.users ALTER COLUMN user_id SET DEFAULT nextval('public.users_user_id_seq'::regclass);
 <   ALTER TABLE public.users ALTER COLUMN user_id DROP DEFAULT;
       public          postgres    false    215    214            N          0    16712    alerts 
   TABLE DATA           �   COPY public.alerts (alert_id, alert_title, alert_who_add_id, alert_details, alert_add_date, alert_exist, alert_machine_id, alert_status, alert_repairer_id) FROM stdin;
    public          postgres    false    216   \J       O          0    16722    alerts_archive 
   TABLE DATA           �   COPY public.alerts_archive (alert_archive_id, alert_title, alert_who_add_id, alert_details, alert_add_date, alert_machine_id, alert_delete_date, alert_repairer_id) FROM stdin;
    public          postgres    false    217   �L       P          0    16731    machines 
   TABLE DATA           i   COPY public.machines (machine_id, machine_name, machine_type, machine_status, machine_exist) FROM stdin;
    public          postgres    false    218   �M       R          0    16736    realize_tasks 
   TABLE DATA           i   COPY public.realize_tasks (realize_id, realize_user_id, realize_machine_id, realize_task_id) FROM stdin;
    public          postgres    false    220   AN       S          0    16740    services 
   TABLE DATA           �   COPY public.services (service_id, service_title, service_machine_id, service_details, service_start_date, service_end_date, service_exist, service_status, service_user_id) FROM stdin;
    public          postgres    false    221   ^N       T          0    16749    serwices_archive 
   TABLE DATA           �   COPY public.serwices_archive (service_archive_id, service_title, service_machine_id, service_details, service_start_date, service_end_date, service_delete_data, service_user_id) FROM stdin;
    public          postgres    false    222   ?P       U          0    16757    tasks 
   TABLE DATA           �   COPY public.tasks (task_id, task_title, task_details, task_add_date, task_start_date, task_end_date, task_exist, task_start_date_by_user) FROM stdin;
    public          postgres    false    223   wQ       V          0    16764    tasks_archive 
   TABLE DATA           �   COPY public.tasks_archive (task_archive_id, task_title, task_details, task_add_date, task_start_date, task_end_date, task_start_date_by_user, task_delete_time) FROM stdin;
    public          postgres    false    224   �R       L          0    16704    users 
   TABLE DATA              COPY public.users (user_id, user_name, user_surname, user_email, user_login, user_password, user_role, user_exist) FROM stdin;
    public          postgres    false    214   T       _           0    0    machines_machine_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.machines_machine_id_seq', 116, true);
          public          postgres    false    219            `           0    0    users_user_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.users_user_id_seq', 109, true);
          public          postgres    false    215            �           2606    16774    alerts_archive alerts_a_pkay 
   CONSTRAINT     h   ALTER TABLE ONLY public.alerts_archive
    ADD CONSTRAINT alerts_a_pkay PRIMARY KEY (alert_archive_id);
 F   ALTER TABLE ONLY public.alerts_archive DROP CONSTRAINT alerts_a_pkay;
       public            postgres    false    217            �           2606    16776    alerts alerts_pkay 
   CONSTRAINT     V   ALTER TABLE ONLY public.alerts
    ADD CONSTRAINT alerts_pkay PRIMARY KEY (alert_id);
 <   ALTER TABLE ONLY public.alerts DROP CONSTRAINT alerts_pkay;
       public            postgres    false    216            �           2606    16778    machines machines_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.machines
    ADD CONSTRAINT machines_pkey PRIMARY KEY (machine_id);
 @   ALTER TABLE ONLY public.machines DROP CONSTRAINT machines_pkey;
       public            postgres    false    218            �           2606    16780    realize_tasks mut_pkay 
   CONSTRAINT     \   ALTER TABLE ONLY public.realize_tasks
    ADD CONSTRAINT mut_pkay PRIMARY KEY (realize_id);
 @   ALTER TABLE ONLY public.realize_tasks DROP CONSTRAINT mut_pkay;
       public            postgres    false    220            �           2606    16782    serwices_archive serwic_a_pkay 
   CONSTRAINT     l   ALTER TABLE ONLY public.serwices_archive
    ADD CONSTRAINT serwic_a_pkay PRIMARY KEY (service_archive_id);
 H   ALTER TABLE ONLY public.serwices_archive DROP CONSTRAINT serwic_a_pkay;
       public            postgres    false    222            �           2606    16784    services serwic_pkay 
   CONSTRAINT     Z   ALTER TABLE ONLY public.services
    ADD CONSTRAINT serwic_pkay PRIMARY KEY (service_id);
 >   ALTER TABLE ONLY public.services DROP CONSTRAINT serwic_pkay;
       public            postgres    false    221            �           2606    16786    tasks_archive tasks_a_pkay 
   CONSTRAINT     e   ALTER TABLE ONLY public.tasks_archive
    ADD CONSTRAINT tasks_a_pkay PRIMARY KEY (task_archive_id);
 D   ALTER TABLE ONLY public.tasks_archive DROP CONSTRAINT tasks_a_pkay;
       public            postgres    false    224            �           2606    16788    tasks tasks_pkay 
   CONSTRAINT     S   ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_pkay PRIMARY KEY (task_id);
 :   ALTER TABLE ONLY public.tasks DROP CONSTRAINT tasks_pkay;
       public            postgres    false    223            �           2606    16790    users users_pkey 
   CONSTRAINT     S   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);
 :   ALTER TABLE ONLY public.users DROP CONSTRAINT users_pkey;
       public            postgres    false    214            �           2620    16791    alerts archive_deleted_alert    TRIGGER     x   CREATE TRIGGER archive_deleted_alert AFTER DELETE ON public.alerts FOR EACH ROW EXECUTE FUNCTION public.delete_alert();
 5   DROP TRIGGER archive_deleted_alert ON public.alerts;
       public          postgres    false    216    225            �           2620    16792    services deleteservice    TRIGGER     t   CREATE TRIGGER deleteservice AFTER DELETE ON public.services FOR EACH ROW EXECUTE FUNCTION public.delete_service();
 /   DROP TRIGGER deleteservice ON public.services;
       public          postgres    false    226    221            �           2620    16793    tasks deletetasktrigger    TRIGGER     s   CREATE TRIGGER deletetasktrigger BEFORE DELETE ON public.tasks FOR EACH ROW EXECUTE FUNCTION public.delete_task();
 0   DROP TRIGGER deletetasktrigger ON public.tasks;
       public          postgres    false    223    227            �           2606    16799    realize_tasks machine_fkay    FK CONSTRAINT     �   ALTER TABLE ONLY public.realize_tasks
    ADD CONSTRAINT machine_fkay FOREIGN KEY (realize_machine_id) REFERENCES public.machines(machine_id) NOT VALID;
 D   ALTER TABLE ONLY public.realize_tasks DROP CONSTRAINT machine_fkay;
       public          postgres    false    218    220    3242            �           2606    16830    services machine_fkay    FK CONSTRAINT     �   ALTER TABLE ONLY public.services
    ADD CONSTRAINT machine_fkay FOREIGN KEY (service_machine_id) REFERENCES public.machines(machine_id) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 ?   ALTER TABLE ONLY public.services DROP CONSTRAINT machine_fkay;
       public          postgres    false    3242    218    221            �           2606    16825    alerts machine_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.alerts
    ADD CONSTRAINT machine_fkey FOREIGN KEY (alert_machine_id) REFERENCES public.machines(machine_id) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 =   ALTER TABLE ONLY public.alerts DROP CONSTRAINT machine_fkey;
       public          postgres    false    216    218    3242            �           2606    16809    realize_tasks taask_fkay    FK CONSTRAINT     �   ALTER TABLE ONLY public.realize_tasks
    ADD CONSTRAINT taask_fkay FOREIGN KEY (realize_task_id) REFERENCES public.tasks(task_id) NOT VALID;
 B   ALTER TABLE ONLY public.realize_tasks DROP CONSTRAINT taask_fkay;
       public          postgres    false    220    223    3250            �           2606    16814    alerts user_fkay    FK CONSTRAINT     �   ALTER TABLE ONLY public.alerts
    ADD CONSTRAINT user_fkay FOREIGN KEY (alert_who_add_id) REFERENCES public.users(user_id) NOT VALID;
 :   ALTER TABLE ONLY public.alerts DROP CONSTRAINT user_fkay;
       public          postgres    false    3236    216    214            �           2606    16819    realize_tasks user_fkay    FK CONSTRAINT     �   ALTER TABLE ONLY public.realize_tasks
    ADD CONSTRAINT user_fkay FOREIGN KEY (realize_user_id) REFERENCES public.users(user_id) NOT VALID;
 A   ALTER TABLE ONLY public.realize_tasks DROP CONSTRAINT user_fkay;
       public          postgres    false    3236    220    214            N   U  x�}�͎�0���)|�aw���[�Ti�^zI7	1��P�+�!�]zܾW�!,$�&�~���H�k�C~�6���� ��\��uB3� HG�|j����
�T����A�t��BS�k�'�[�5"�|y�R��*�_����b��^���������uݽЏkO��_��>n�"�C�q�_Ək_-�
���|�_� i�\9a�p'�un	��lq��.��WV�9�E�t\2e��\�$e^�mO�>bS�Q-ô��A��s�D��@��z�XE$���ŭ��<�i`��2�n/l9���;Rf����o/u�f�"��ލ�����aJ�����Q����	�r�0���QD�!M���HR���f�G���Ry7������°��w봉�(a�f`H��߿�#�Na��i"W����|�EW�t��M���_�?���=�l�~��U�g����O�K߳�l���NZ��8M踄��0��Ng��i�gB��.�����Z��:nI�*f{[V3㐒�@���m�	8%��c�B�
�Z�����F��ǰ@3c�9��KT3{>��v1��l6���lf�      O   �   x���Mj�0F��)f_,4�X:G��FuU��t��'�\�B�Ma6����
�q.P!,%�`v!��'8xt^in�yi�ghzt��#��֡R[ޡP���p���y�s����q�ohR�j��P�],�kͭu��M#[v��)=>��z����1���oi.yU��zE\�o�]����I(�y���>�f�pS�,�����6���������x�u_~�[�      P   �   x�e�=�0�緧�	LJ@fÀ.2��7��gMKJI�7�>L\q}~�CS"����=����goS��-��#�Ƞ[mۅ1�dQ���hu/�aL�>ҿ膻\��/A�������e�N����71      R      x������ � �      S   �  x���M��0���)�/"���{��
̦c䠞 N�0�7�}�`��$��hA�C��#��I�t\� 'R�? ����6��H
����5)ol	�����7}+leH�1��
��ew�%/��u�G���(ci��X$.C�_�RԖ���.�0���w�cj�4&�blRÊ�y���}��#�Z���m�p:�#O2�<,�E+�+y.�x�/��|[���V��[M&j�����C!�u��
O�*mY�|>w��,�ڝ��(�0�`׿� �piN�]+�
F����rqD�9Sk�5�#�V�ޛ'n.Y�.\�EBekmC|���ξ�0x1�y(�S��yl4��8U{|BBDT��׺�J7Z�_���Q��3����a��9�o�� ��Q� ��f�D��˥�3w����Z9���w'�
D#:��2�oi�P:�o]Η��@P�g�������6?3cj^���Cq�WUU�/
+,�      T   (  x����j�0���S�^b$[�=G��x�YGKFY�{��ל�v+�m�m$��>I�����M�r�y���2hl��6(�sb��M:
�X���55@N
��y������V7ѻ�.�V�
��	��6�We�@^,�����.�(��6��0i�.�}ig<}RT��c:eh�Н���� ��#���6�=ʕy��wQZ�1�.�}ԎC�tOV�G8�q�"B�<�K�m���嫂)⼈���6rj�H% Q�ؕ���`#��E��.tk��X�� ]~��0�n��']U�7@���      U   p  x��SɎ� =��Ƚ���}�\*%�=���C���\FX����������N�,gԳ`�T��"�'dG9�ɬG,�NH�o ��SnX��}�r�)�E8����rOZ�GH>n ���P9�
M� ��iv��<��2�������PXAC�䱜P,^���7d�و 7�	�{0֨��+�`�����l����]����]رj��(��u����lcs���Zmr��
*d�{ȣeR���16Z+n�\�gI� qS[��|a�# R����oZ��� Q{r�}�6���>��6Q=j<��Lz �"�HX� �6^$+A�����{��nl�f,��'���+ק��>UӞ!�V���UK�r      V   �   x�u�Mn�0��p
�#,�Ɖ�=G����Ku�
�D��'~vm����D�Yf���D�!��@�J5�b��X��� � ,3�TBK�BѦ�S	˰��:l벭�?�N�Bj ��AH�-Y������.!��H�
���v�1N$�٪��ҕ�β��ŗ��Q���c���l�9vp�f7%$P�ߍ%M�0=�����W8##�˧�RG5iWk����7U*���湷�J���o���?�a      L   �   x�u�M
�0�דÔ�?�At#�K7�F��im���x/�M�q�x3���e�G��A���SHh�X�M�(0�^��-�I��`�J�ǫonh"J��)��j���RB��O'o�� �-�Z�Uǭ+.�J����c����.H�&FZޠh��9u�g�N�em�S����O��y�j�������輗O��}{��x���C�� ��     